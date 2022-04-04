module Solver

export solve

using ..Trees
using ..Tableaus

function applyNonBranching!(tableau::Tableau)
    #=
        Returns true if at least one new rule has been applied
    =#
    flag = false
    for (idx, i) in enumerate(tableau.list)

        if i.applied
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

function applyModal(tableau::Tableau, restrictions::Vector{Char})
    #=
        Returns true if at least one new rule has been applied
    =#    

    #Alternative rules for the GL due to converse well foundedness
    iswf = 'c' in restrictions ? true : false
    d! = iswf ? diaGL! : dia!
    b! = iswf ? boxGL! : box!
    nd! = iswf ? negDiaGL! : negDia!
    nb! = iswf ? negBoxGL! : negBox!

    flag = false
    for (idx, i) in enumerate(tableau.list)

        if i.applied
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

    if flag
        if 't' in restrictions
            transitivity!(tableau)
        if 'r' in restrictions
            reflexivity!(tableau)
        if 's' in restrictions
            symmetry!(tableay)
    end

    return flag
end

function applyBranching!(tableau::Tableau)
    #=
        Returns true if at least one new rule has been applied
    =#

    flag = false
    for (idx, i) in enumerate(tableau.list)

        if i.applied
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

end

function isClosed(list::Vector{NamedTuple{(:formula, :world, :applied), Tuple{Tree, Int32, Bool}}})
    for i in list[:end-1]
        for j in list[i+1:end]
            if isOpposite(i.formula, j.formula)
                return true
            end
        end
    end
    return false
end

function solveBranch!(tableau::Tableau)
    #=
        returns true when the branch is closed and complete, false when the branch is open and complete
    =#
    
    # this loop makes sure that the rules are applied in a correct order as long as there any rules left to be applied
    while !(applyNonBranching!(tableau) && applyModal!(tableau) && applyBranching!(tableau))
    end
    
    return isClosed(tableau.list)
end

function solve(tableau)

    while true
        if solveBranch!(tableau)
            if length(tableau.branches) != 0

                branch = pop!(tableau.branches)

                # remove irrelevant formulas from the current branch (list)
                # remove formulas after the most recent branching
                while length(tableau.list) >= branch.line
                    _ = pop!(tableau)
                end
                
                # while-loop used to accomodate the multiple formulas on a new branch produced by negImp! and imp!
                # we will add all formulas in a new branch to the current branch (list)
                while true
                    tuple1 = (formula = branch.formula, world = branch.world, applied = false)
                    push!(tableau.list, tuple1)
                    if tableau.branches[end].line == branch.line
                        branch = pop!(tableau.branches)
                    else
                        break
                    end
                end
                
                # remove relations introduced on the other branch, leave ones on the common part of that branch
                for r in tableau.relations
                    if r.line >= branch.line
                        _ = pop!(tableau.relations)
                    end
                end
            else
                print("Tableau is closed and complete!")
                break
            end
        else
            print("Tableau has at least one open and complete branch")
            break
        end
    end
end

end #module