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

        if tableau.applied[idx]
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

        if tableau.applied[idx]
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
        if 't' in constraints
            transitivity!(tableau)
        end
        if 'r' in constraints
            reflexivity!(tableau)
        end
        if 's' in constraints
            symmetry!(tableay)
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

        if tableau.applied[idx]
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
    for (idx, i) in enumerate(list[1:end-1])
        # early stopping criterion in case explicit contradiction is ancountered
        if i.formula.connective == "⊥" || (i.formula.connective == '¬' && i.formula.right.connective == '⊤') 
            return true
        end

        for j in list[idx+1:end]
            if isOpposite(i.formula, j.formula)
                return true
            end
        end
    end
    return false
end

function solveBranch!(tableau::Tableau, constraints::Vector{Char})
    #=
        returns true when the branch is closed and complete, false when the branch is open and complete
    =#
    
    # this loop makes sure that the rules are applied in a correct order as long as there any rules left to be applied
    while true
        if !applyNonBranching!(tableau) && !applyModal!(tableau, constraints) && !applyBranching!(tableau)
            break
        end
    end
    
    return isClosed(tableau.list)
end

function solve!(tableau::Tableau, constraints::Vector{Char})

    while true
        if solveBranch!(tableau, constraints)
            if length(tableau.branches) != 0

                branch = pop!(tableau.branches)

                # remove irrelevant formulas from the current branch (list)
                # remove formulas after the most recent branching
                while length(tableau.list) >= branch.line
                    _ = pop!(tableau.list)
                    _ = pop!(tableau.applied)
                end
                
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
            print("Tableau has at least one open and complete branch:\n")
            printBranch(tableau)
            break
        end
    end
end

end #module