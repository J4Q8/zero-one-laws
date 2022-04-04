module ModalRules

export dia!, box!, negDia!, negBox!, diaGL!, boxGL!, transitivity!, reflexivity!, symmetry!

using ..Trees
using ..Tableaux

function firstEmptyWorld(tableau::Tableau)
    max = 0
    for i in tableau.relations
        new_max = max(i.i, i.j)
        if new_max > max
            max = new_max
        end
    end
    return max + 1
end

function refreshBox!(tableau::Tableau)
    for (idx, i) in enumerate(tableau.list)
        if i.formula.connective == '◻'
            tableau.applied[idx] = false
        end
    end
end

function isOnList(tableau::Tableau, t::NamedTuple{(:formula, :world), Tuple{Tree, Int64}})
    for i in tableau.list
        if isEqual(t.formula,i.formula) && t.world == i.world
            return true
        end
    end
    return false
end

function dia!(tableau::Tableau, idx::Int64)
    t = tableau.list[idx]
    formula = t.formula

    # rule for ◇
    j = firstEmptyWorld(tableau)
    relation = (i = t.world, j = j, line = idx)
    push!(tableau.relations, relation)

    addFormula!(tableau, formula.right, j)

    #mark this rule as applied and make sure all boxes are checked for the new relations
    tableau.applied[idx] = true
    refreshBox!(tableau)
end

function box!(tableau::Tableau, idx::Int64)
    t = tableau.list[idx]
    formula = t.formula
    
    # rule for '◻'
    for i in tableau.relations
        if t.world == i.i
            tuple1 = (formula = formula.right, world = i.j, applied = false)
            if !isOnList(tableau, tuple1)
                push!(tableau.list, tuple1)
                push!(tableau.applied, false)
            end
        end
    end

    tableau.applied[idx] = true
end

function negDia!(tableau::Tableau, idx::Int64)
    t = tableau.list[idx]
    formula = t.formula.right.right

    f1 = Tree('◻')
    f2 = Tree('¬')
    addrightchild!(f1,f2)
    addrightchild!(f2, formula)
    addFormula!(tableau, f1, t.world)

    tableau.applied[idx] = true
end

function negBox!(tableau::Tableau, idx::Int64)
    t = tableau.list[idx]
    formula = t.formula.right.right

    f1 = Tree('◇')
    f2 = Tree('¬')
    addrightchild!(f1,f2)
    addrightchild!(f2, formula)
    addFormula!(tableau, f1, t.world)

    tableau.applied[idx] = true
end

function diaGL!(tableau::Tableau, idx::Int64)
    t = tableau.list[idx]
    formula = t.formula

    # rule for ◇ for GL
    j = firstEmptyWorld(tableau)
    relation = (i = t.world, j = j, line = idx)
    push!(tableau.relations, relation)

    f1 = Tree('¬')
    f2 = Tree('◇')
    addrightchild!(f1,f2)
    addrightchild!(f2, formula.right)
    addFormula!(tableau, f1, j)
    addFormula!(tableau, formula.right, j)

    #mark this rule as applied and make sure all boxes are checked for the new relations
    tableau.applied[idx] = true
    refreshBox!(tableau)
end

function boxGL!(tableau::Tableau, idx::Int64)

    t = tableau.list[idx]
    formula = t.formula
    
    # rule for '◻' for GL
    for i in tableau.relations
        if t.world == i.i

            f1 = Tree('◻')
            addrightchild!(f1, formula.right)
            tuple1 = (formula = f1, world = i.j)
            tuple2 = (formula = formula.right, world = i.j)

            if !isOnList(tableau, tuple1) && !isOnList(tableau, tuple2)
                push!(tableau.list, tuple1)
                push!(tableau.applied, false)
                push!(tableau.list, tuple2)
                push!(tableau.applied, false)
            end
        end
    end

    tableau.applied[idx] = true
end

function transitivity!(tableau::Tableau)
    flag = false
    for (idx, l) in tableau.relations
        #I have to use the this case instead of slicing to be able to use dynamic arrays
        if idx > length(tableau.relations) -1
            continue
        end

        for (idx2, k) in tableau.relations
             #I have to use the this case instead of slicing to be able to use dynamic arrays
            if idx2 <= idx
                continue
            end

            if l.j == k.i
                relation = (i = l.i, j = k.j, line = max(l.line, k.line))
                if !(relation in tableau.relations)
                    push!(tableau.relations, relation)
                    flag = true
                end
            end
        end
    end
    if flag
        refreshBox!(tableau)
    end
end

function reflexivity!(tableau::Tableau)
    worlds = []
    flag = false
    for (idx, l) in enumerate(tableau.list)
        if !(l.world in worlds)
            push!(worlds, l.world)
            relation = (i = l.world, j = l.world, line = idx)
            if !(relation in tableau.relations)
                push!(tableau.relations, relation)
                flag = true
            end
        end
    end
    if flag 
        refreshBox!(tableau)
    end
end

function symmetry!(tableau::Tableau)
    flag = false
    for r in tableau.relations
        relation = (i = r.j, j = r.l, line = r.line)
        if !(relation in tableau.relations)
            push!(tableau.relations, relation)
            flag = true
        end
    end
    if flag 
        refreshBox!(tableau)
    end
end

end #module