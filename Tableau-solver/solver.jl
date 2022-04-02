module Solver

export solve, Tableau

using ..Trees

mutable struct Tableau
    #keeps track of the current branch
    list::Vector{NamedTuple{(:formula, :world, :applied), Tuple{Tree, Int32, Bool}}}
    #this will keep track of branches to be explored
    branches::Vector{NamedTuple{(:formula, :line), Tuple{Tree, Int32}}}
    #keeps track of relations
    relations::Vector{NamedTuple{(:i, :j, :line), Tuple{Int32, Int32, Int32}}}

    #root constructor
    Tableau(initiallist) = new(initiallist)
end

function solve(tableau)

    
    while applyRules!(tableau)
    end


end

function applyRules!(tableau::Tableau)
    posNonBranching = ['∧','◻','◇']
    negNonBranching = ['∨', '¬', '→', '◻', '◇']
    posBranching = ['∨', '→', '↔']
    negBranching = ['∧', '↔']

    for i in tableau.list
        if i.applied
            continue
        end
        c = i.formula.connective 
        if c == '¬'
            if c in negNonBranching
                #We pass the formula itself, without preceding ¬
                applyNegNonBranching!(tableau, i.formula.rightchild, i.world)
            else
                #We pass the formula itself, without preceding ¬
                applyNegBranching!(tableau, i.formula.rightchild)
            end
        else
            if c in posNonBranching
                applyPosNonBranching!(tableau, i.formula)
            else
                applyPosBranching!(tableau, i.formula)
            end
        end
    end
end

function applyNegNonBranching!(tableau::Tableau, formula::Tree, world::Int32)
    c = formula.connective
    if c == '∨'
        # rule for ¬∨
        f1 = Tree('¬')
        addrightchild!(f1, formula.left)
        tuple1 = (formula = f1, world = world, applied = false)
        push!(tableau.list, tuple1)

        f2 = Tree('¬')
        addrightchild!(f2, formula.right)
        tuple1 = (formula = f2, world = world, applied = false)
        push!(tableau.list, tuple1) 

    elseif c == '¬'
        f1 = formula.right
    end

end


end #module