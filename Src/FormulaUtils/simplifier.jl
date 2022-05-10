module Simplifier

using ..Trees

export simplify, rebuildTreeFromJuncts

function simplifyChildren(formula::Tree)
    connective = Tree(formula.connective)
    if isdefined(formula, :left)
        addleftchild!(connective, simplify(formula.left))
    end
    if isdefined(formula, :right)
        addrightchild!(connective, simplify(formula.right))
    end
    return connective
end

function getJuncts(formula::Tree, connective::Char)
    # get conjuncts and disjuncts
    if formula.connective == connective
        return [getJuncts(formula.left, connective); getJuncts(formula.right, connective)]
    else
        return formula
    end

end

function anyOppositeFormulas(juncts::Vector{Tree})
    for (idx, junct1) in enumerate(juncts[2:end-1])
        for junct2 in juncts[idx:end]
            if isOppositeEqui(junct1, junct2)
                return true
            end
        end
    end
    return false
end

function rebuildTreeFromJuncts(connective::Char, juncts::Vector{Tree})
    if length(juncts) == 1
        return juncts[1]
    elseif length(juncts) > 1
        root = Tree(connective)
        addleftchild!(root, juncts[1])
        addrightchild!(root, rebuildTreeFromJuncts(connective, juncts[2:end]))
        return root
    else
        throw(DomainError(juncts, "This should never be empty"))
    end
end

function getRepeatingJuncts(juncts::Vector{Tree})
    repeating = Vector{Int64}[]
    for (idx1, junct1) in enumerate(juncts[2:end-1])
        for (idx2, junct2) in enumerate(juncts[idx1:end])
            if isEquivalent(junct1, junct2)
                #add to list of repeating formulas
                added = false
                for r in repeating
                    if idx1 ∈ r
                        push!(r, idx2)
                        added = true
                    end
                end
                if !added
                    push!(repeating, [idx1, idx2])  
                end              
            end
        end
    end
    return repeating
end

function reduceRepeatingJuncts(connective::Char, juncts::Vector{Tree})
    repeating = getRepeatingJuncts(juncts)
    # remove repeating formulas
    for r in repeating
        deleteat!(juncts, r[2:end])
    end

    idx2Remove = Int64[]
    for (idx, junct) in enumerate(juncts)
        if connective == '∧' && isEquivalent(junct, Tree('⊤'))
            push!(idx2Remove, idx)
        elseif connective == '∨' && isEquivalent(junct, Tree('⊥'))
            push!(idx2Remove, idx)
        end
    end
    deleteat!(juncts, idx2Remove)

    # recreate tree structure using juncts
    return rebuildTreeFromJuncts(connective, juncts)
end

function replaceRepeatingJunctsWithT(connective::Char, juncts::Vector{Tree})
    repeating = getRepeatingJuncts(juncts)

    flag = false
    for r in repeating
        deleteat!(juncts, r)
        flag = true
    end

    # for biconditional we can rearrange juncts in a way that all repeating elements will be next to each other
    # then all repeating formulas of the same time can be replaced with 'T'
    # if there is more than 1 repeating formula then we can still replace it with just one 'T', 
    # because we can rearrange them into (T <-> T) <-> T, which is T
    if flag
        push!(juncts, Tree('⊤'))
    end

    return juncts
end

function getOppositeJuncts(juncts::Vector{Tree})
    opposite = Vector{Int64}[]
    for (idx1, junct1) in enumerate(juncts[2:end-1])
        for (idx2, junct2) in enumerate(juncts[idx1:end])
            if isOppositeEqui(junct1, junct2)
                #add to list of repeating formulas
                if !added
                    push!(opposite, [idx1, idx2])  
                end              
            end
        end
    end
    return opposite
end

function replaceOppositeJunctsWithF(connective::Char, juncts::Vector{Tree})
    opposite = getOppositeJuncts(juncts)

    unzipped = sort!([i for o in opposite for i in o])

    for (idx, val) in unzipped[1:end-1]
        if val == unzipped[idx+1]
            throw(ErrorException("This should never happen, call replace repeating juncts with T before"))
        end
    end

    falseCount = 0
    for o in opposite
        deleteat!(juncts, o)
        falseCount = falseCount + 1
    end
    
    if isodd(falseCount)
        push!(juncts, Tree('⊥'))
    else
        push!(juncts, Tree('⊤'))
    end
    return juncts
end

function simplifyConj(formula::Tree)

    juncts = getJuncts(formula, formula.connective)

    if formula.left.connective == '⊥' || formula.right.connective == '⊥' || anyOppositeFormulas(juncts)
        return Tree('⊥')
    end

    reducedFormula = reduceRepeatingJuncts(formula.connective, juncts)
    return simplifyChildren(reducedFormula)
end

function simplifyDisj(formula::Tree)
    
    juncts = getJuncts(formula, formula.connective)

    if formula.left.connective == '⊤' || formula.right.connective == '⊤' || anyOppositeFormulas(juncts)
        return Tree('⊤')
    end

    reducedFormula = reduceRepeatingJuncts(formula.connective, juncts)
    return simplifyChildren(reducedFormula)
end

function simplifyImp(formula::Tree)
    if formula.left.connective == '⊥'
        return Tree('⊤') 
    elseif formula.right.connective == '⊤'
        return Tree('⊤')
    elseif formula.left.connective == '⊤' && formula.right.connective == '⊥'
        return Tree('⊥') 
    else
        return simplifyChildren(formula)
    end
end

function simplifyBiImp(formula::Tree)
    # first reduce repeating then opposite
    juncts = getJuncts(formula, formula.connective)
    juncts = replaceRepeatingJunctsWithT(formula.connective, juncts)
    juncts = replaceOppositeJunctsWithF(formula.connective, juncts)
    reducedFormula = rebuildTreeFromJuncts(formula.connective, juncts)
    return simplifyChildren(reducedFormula)
end

function simplifyNeg(formula::Tree)
    if formula.right.connective == '¬'
        return simplify(formula.right.right)
    elseif formula.right.connective == '⊥'
        Tree('⊤')
    elseif formula.right.connective == '⊤'
        Tree('⊥')
    else
        return simplifyChildren(formula)
    end
end

function simplifyDia(formula::Tree)
    if formula.right.connective == '⊥'
        return Tree('⊥')
    else
        return simplifyChildren(formula)
    end
end

function simplifyBox(formula::Tree)
    if formula.right.connective == '⊤'
        return Tree('⊤')
    else
        return simplifyChildren(formula)
    end
end

function simplifySwitch(formula::Tree)
    if formula.connective == '∧'
        return simplifyConj(formula)
    elseif formula.connective == '→'
        return simplifyImp(formula)
    elseif formula.connective == '↔'
        return simplifyBiImp(formula)
    elseif formula.connective == '∨'
        return simplifyDisj(formula)
    elseif formula.connective == '¬'
        return simplifyNeg(formula)
    elseif formula.connective == '◇'
        return simplifyDia(formula)
    elseif formula.connective == '◻'
        return simplifyBox(formula)
    else
        return formula
    end
end

function simplify(formula::Tree)
    steadystate = deepcopy(formula)
    simplified = simplifySwitch(formula)
    while !isEqual(steadystate, simplified)
        steadystate = deepcopy(simplified)
        simplified = simplify(simplified)
    end
    return simplified
end

end #module