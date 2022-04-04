module PropositionalRules

export negNeg!, negBiImp!, negCon!, negDis!, negImp!, con!, dis!, imp!, biImp!

using ..Trees
using ..Tableaux

function negDisj!(tableau::Tableau, idx::Int64)
    #=
        tableau:    takes a current tableau
        idx:        takes an index of formula to which we apply this rule

        This function will add resulting formulas to the current branch (list)
            and will set the "applied" flag of the original formula to true
    =#

    t = tableau.list[idx]
    formula = t.formula.right

    # rule for ¬∨
    f1 = Tree('¬')
    addrightchild!(f1, formula.left)
    tuple1 = (formula = f1, world = t.world, applied = false)
    push!(tableau.list, tuple1)

    f2 = Tree('¬')
    addrightchild!(f2, formula.right)
    tuple2 = (formula = f2, world = t.world, applied = false)
    push!(tableau.list, tuple2) 

    t.applied = true
end

function negNeg!(tableau::Tableau, idx::Int64)
    #=
        tableau:    takes a current tableau
        idx:        takes an index of formula to which we apply this rule

        This function will add resulting formulas to the current branch (list)
            and will set the "applied" flag of the original formula to true
    =#

    t = tableau.list[idx]
    formula = t.formula.right

    # rule for ¬¬
    tuple = (formula = formula.right, world = t.world, applied = false)
    push!(tableau.list, tuple)

    t.applied = true
end

function con!(tableau::Tableau, idx::Int64)
    #=
        tableau:    takes a current tableau
        idx:        takes an index of formula to which we apply this rule

        This function will add resulting formulas to the current branch (list)
            and will set the "applied" flag of the original formula to true
    =#
    t = tableau.list[idx]
    formula = t.formula

    # rule for ∧
    tuple1 = (formula = formula.right, world = t.world, applied = false)
    push!(tableau.list, tuple1)

    tuple2 = (formula = formula.left, world = t.world, applied = false)
    push!(tableau.list, tuple2) 

    t.applied = true
end

function negImp!(tableau::Tableau, idx::Int64)
    #=
        tableau:    takes a current tableau
        idx:        takes an index of formula to which we apply this rule

        This function will add resulting formulas to the current branch (list)
            and will set the "applied" flag of the original formula to true
    =#

    t = tableau.list[idx]
    formula = t.formula.right

    # rule for ¬→
    tuple1 = (formula = formula.left, world = t.world, applied = false)
    push!(tableau.list, tuple1)

    f2 = Tree('¬')
    addrightchild!(f2, formula.right)
    tuple2 = (formula = f2, world = t.world, applied = false)
    push!(tableau.list, tuple2) 

    t.applied = true
end

function negCon!(tableau::Tableau, idx::Int64)
    #=
        tableau:    takes a current tableau
        idx:        takes an index of formula to which we apply this rule

        This function will add one of the resulting formulas to the current branch (list),
            add the other resulting formula to a stack of branches along with its desired line number
            and will set the "applied" flag of the original formula to true
    =#
    t = tableau.list[idx]
    formula = t.formula.right

    # rule for ¬∧
    f1 = Tree('¬')
    addrightchild!(f1, formula.left)
    tuple1 = (formula = f1, world = t.world, applied = false)
    push!(tableau.list, tuple1)

    f2 = Tree('¬')
    addrightchild!(f2, formula.right)
    tuple2 = (formula = f2, world = t.world, line = idx + 1)
    push!(tableau.branches, tuple2)

    t.applied = true
end

function dis!(tableau::Tableau, idx::Int64)
    #=
        tableau:    takes a current tableau
        idx:        takes an index of formula to which we apply this rule

        This function will add one of the resulting formulas to the current branch (list),
            add the other resulting formula to a stack of branches along with its desired line number
            and will set the "applied" flag of the original formula to true
    =#
    t = tableau.list[idx]
    formula = t.formula

    # rule for ∨
    tuple1 = (formula = formula.left, world = t.world, applied = false)
    push!(tableau.list, tuple1)

    tuple2 = (formula = formula.right, world = t.world, line = idx + 1)
    push!(tableau.branches, tuple2)
    
    t.applied = true
end

function imp!(tableau::Tableau, idx::Int64)
    #=
        tableau:    takes a current tableau
        idx:        takes an index of formula to which we apply this rule

        This function will add one of the resulting formulas to the current branch (list),
            add the other resulting formula to a stack of branches along with its desired line number
            and will set the "applied" flag of the original formula to true
    =#
    t = tableau.list[idx]
    formula = t.formula

    # rule for →
    f1 = Tree('¬')
    addrightchild!(f1, formula.left)
    tuple1 = (formula = f1, world = t.world, applied = false)
    push!(tableau.list, tuple1)

    tuple2 = (formula = formula.right, world = t.world, line = idx + 1)
    push!(tableau.branches, tuple2)
    
    t.applied = true
end

function biImp!(tableau::Tableau, idx::Int64)
    #=
        tableau:    takes a current tableau
        idx:        takes an index of formula to which we apply this rule

        This function will add two of the resulting formulas to the current branch (list),
            add the other two resulting formula to a stack of branches along with its desired line number 
            (both of them will be given the same line number)
            and will set the "applied" flag of the original formula to true
    =#

    t = tableau.list[idx]
    formula = t.formula

    # rule for ↔
    tuple1 = (formula = formula.left, world = t.world, applied = false)
    push!(tableau.list, tuple1)

    tuple2 = (formula = formula.right, world = t.world, applied = false)
    push!(tableau.list, tuple2) 

    f1 = Tree('¬')
    addrightchild!(f1, formula.left)
    tuple3 = (formula = f1, world = t.world, line = idx + 1)
    push!(tableau.branches, tuple3)

    f2 = Tree('¬')
    addrightchild!(f1, formula.right)
    tuple4 = (formula = f2, world = t.world, line = idx + 1)
    push!(tableau.branches, tuple4)    

    t.applied = true
end

function negBiImp!(tableau::Tableau, idx::Int64)
    #=
        tableau:    takes a current tableau
        idx:        takes an index of formula to which we apply this rule

        This function will add two of the resulting formulas to the current branch (list),
            add the other two resulting formula to a stack of branches along with its desired line number 
            (both of them will be given the same line number)
            and will set the "applied" flag of the original formula to true
    =#

    t = tableau.list[idx]
    formula = t.formula.right

    # rule for ¬↔
    tuple1 = (formula = formula.left, world = t.world, applied = false)
    push!(tableau.list, tuple1)

    f2 = Tree('¬')
    addrightchild!(f1, formula.right)
    tuple2 = (formula = f2, world = t.world, applied = false)
    push!(tableau.list, tuple2)

    f3 = Tree('¬')
    addrightchild!(f2, formula.left)
    tuple3 = (formula = f3, world = t.world, line = idx + 1)
    push!(tableau.branches, tuple3)   

    tuple4 = (formula = formula.right, world = t.world, line = idx + 1)
    push!(tableau.branches, tuple4)

    t.applied = true
end
    
end #module