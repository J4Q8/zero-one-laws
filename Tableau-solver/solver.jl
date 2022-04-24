module Solver

export solve!

using ..Trees
using ..Tableaux
using ..ModalRules
using ..PropositionalRules

function applyNonBranching!(tableau::Tableau)
    #=
        Returns true if at least one new rule has been applied
    =#
    flag = false
    for (idx, i) in enumerate(tableau.list)

        if tableau.applied[idx] != 0
            continue
        end

        if i.formula.connective == '∧'
            con!(tableau, idx)
            flag = true
        elseif i.formula.connective == '¬'
            f = i.formula.right
            if f.connective == '∨'
                negDis!(tableau, idx)
                flag = true
            elseif f.connective == '¬'
                negNeg!(tableau, idx)
                flag = true
            elseif f.connective == '→'
                negImp!(tableau, idx)
                flag = true
            end
        end
    end
    return flag
end

function applyModal!(tableau::Tableau, constraints::Vector{Char})
    #=
        Returns true if at least one new rule has been applied
    =#    

    #Alternative rules for the GL due to converse well foundedness
    iswf = 'c' in constraints ? true : false
    d! = iswf ? diaGL! : dia!
    b! = iswf ? boxGL! : box!
    #nd! = iswf ? negDiaGL! : negDia! # I DON' THINK IT IS NECESSARY TO HAVE SPECIAL SHORTCUT RULES FOR GL
    nd! = negDia!
    #nb! = iswf ? negBoxGL! : negBox!
    nb! = negBox!

    flag = false
    for (idx, i) in enumerate(tableau.list)

        if tableau.applied[idx] != 0
            continue
        end

        c = i.formula.connective
        if c == '◇'
            d!(tableau, idx)
            flag = true
        elseif c == '◻' && length(tableau.relations) != 0
            b!(tableau, idx)
            flag = true
        elseif c == '¬'
            f = i.formula.right
            if f.connective == '◻'
                nb!(tableau, idx)
                flag = true
            elseif f.connective == '◇' && length(tableau.relations) != 0
                nd!(tableau, idx)
                flag = true
            end
        end
    end

    #reflexivity has to be applied even if there are no relations introduced yet
    #if new relations have been added we need to run the algorithm again
    if 'r' in constraints
        flag = reflexivity!(tableau) || flag
    end

    
    while true
        flag1 = false
        flag2 = false
        
        if 't' in constraints
            flag1 = transitivity!(tableau)
            if flag1
                flag = true
            end
        end
        
        if 's' in constraints
            flag2 = symmetry!(tableau)
            if flag2
                flag = true
            end
        end
        if !flag1 && !flag2
            break
        end
    end

    return flag
end

function applyBranching!(tableau::Tableau)
    #=
        Returns true if at least one new rule has been applied
    =#

    flag = false
    for (idx, i) in enumerate(tableau.list)

        if tableau.applied[idx] != 0
            continue
        end

        c = i.formula.connective
        if c == '∨'
            dis!(tableau, idx)
            flag = true
        elseif c == '→'
            imp!(tableau, idx)
            flag = true
        elseif c == '↔'
            biImp!(tableau, idx)
            flag = true
        elseif c == '¬'
            f = i.formula.right
            if f.connective == '∧'
                negCon!(tableau, idx)
                flag = true
            elseif f.connective == '↔'
                negBiImp!(tableau, idx)
                flag = true
            end
        end
    end
    return flag
end

function isClosed(list::Vector{NamedTuple{(:formula, :world), Tuple{Tree, Int64}}})
    for i in list
        # stopping criterion in case explicit contradiction is ancountered
        if i.formula.connective == '⊥' || (i.formula.connective == '¬' && i.formula.right.connective == '⊤') 
            return true
        end 
    end
    for (idx, i) in enumerate(list[1:end-1])
        for j in list[idx+1:end]
            if isOpposite(i.formula, j.formula) && i.world == j.world
                return true
            end
        end
    end
    return false
end

function isInfinite(tableau::Tableau)
    #after this many worlds are introduced the infinite check will be called
    THRESHOLD = 15

    worlds = Int64[]
    for r in tableau.relations
        if !(r.i in worlds)
            push!(worlds, r.i)
        end
        if !(r.j in worlds)
            push!(worlds, r.j)
        end
    end

    if length(worlds) > THRESHOLD
        counter = 0
        lastworld = maximum(worlds)
        f2check = Tree[]
        for l in tableau.list
            if l.world == lastworld
                push!(f2check, l.formula)
            end
        end
        for w in worlds
            check = 0
            for f in f2check
                if isOnList(tableau, (formula = f, world = w))
                    check = 1 + check
                end
            end
            if check == length(f2check)
                counter = 1 + counter
            end
        end
        if counter > THRESHOLD 
            return true
        end
    end
    return false
end

function solveBranch!(tableau::Tableau, constraints::Vector{Char}, mode::Int64 = 1)
    #=
        returns true when the branch is closed and complete, false when the branch is open and complete
    =#
    
    # this loop makes sure that the rules are applied in a correct order as long as there any rules left to be applied
    while true
        if isInfinite(tableau)
            if mode == 1
                println("Infinite branch!")
            end
            break
        end
        # printBranch(tableau)
        # println("-----------------------------------------")
        if (!applyNonBranching!(tableau) && !applyModal!(tableau, constraints) && !applyBranching!(tableau)) || isClosed(tableau.list) 
            break
        end
    end
    
    return isClosed(tableau.list) 
end

function solve!(tableau::Tableau, constraints::Vector{Char}, mode::Int64 = 1)
    #mode == 1 : print, no return
    #mode == 2 : no print, return
    
    while true
        if solveBranch!(tableau, constraints, mode)
            if length(tableau.branches) != 0

                branch = pop!(tableau.branches)

                # remove irrelevant formulas from the current branch (list)
                # remove formulas after the most recent branching
                while length(tableau.list) >= branch.line
                    _ = pop!(tableau.list)
                    _ = pop!(tableau.applied)
                end
                
                # make sure that all rules that have been applied after branching are applied again on a new branch
                for (i,f) in enumerate(tableau.applied)
                    if f > branch.line
                        tableau.applied[i] = 0
                    end
                end

                # remove relations introduced on the other branch, leave ones on the common part of that branch
                idx2remove = Int64[]
                for (i,r) in enumerate(tableau.relations)
                    if r.line >= branch.line
                        push!(idx2remove,i)
                    end
                end
                deleteat!(tableau.relations, idx2remove)
                
                # while-loop used to accomodate the multiple formulas on a new branch produced by negImp! and imp!
                # we will add all formulas in a new branch to the current branch (list)
                while true
                    addFormula!(tableau, branch.formula, branch.world)
                    if length(tableau.branches) > 0 && tableau.branches[end].line == branch.line
                        branch = pop!(tableau.branches)
                    else
                        break
                    end
                end

            else
                if mode == 1
                    print("Tableau is closed and complete!")
                    break
                else
                    return true
                end
            end
        else
            if mode == 1
                print("Tableau has at least one open and complete branch:\n")
                printBranch(tableau)
                print(tableau.relations)
                print(tableau.applied)
                break
            else
                return false
            end
        end
    end
end

end #module