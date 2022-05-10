module Simplifier

using ..Trees

export simplifyLoop

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

function areChildrenOppositeAssociativity(formula::Tree)
    connective = formula.connective
    juncts = getJuncts(formula, connective)
    for (idx, junct1) in enumerate(juncts[2:end-1])
        for junct2 in juncts[idx:end]
            if isOppositeEqui(junct1, junct2)
                return true
            end
        end
    end
    return false
end

function simplifyConj(formula::Tree)
    if formula.left.connective == '⊥' || formula.right.connective == '⊥' || areChildrenOppositeAssociativity(formula)
        return Tree('⊥')
    elseif formula.left.connective == '⊤'
        return simplify(formula.right)
    elseif formula.right.connective == '⊤'
        return simplify(formula.left)
    else
        return simplifyChildren(formula)
    end
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
    if isEquivalent(formula.left, formula.right)
        return Tree('⊤')
    elseif isOppositeEqui(formula.left, formula.right)
        return Tree('⊥')
    elseif formula.right.connective == '¬' && isEquivalent(formula.right.right, formula.left)
        return Tree('⊥')
    elseif formula.left.connective == '⊥' && formula.right.connective == '⊤'
        return Tree('⊥')
    elseif formula.right.connective == '⊥' && formula.left.connective == '⊤'
        return Tree('⊥')
    else
        return simplifyChildren(formula)
    end
end

function simplifyDisj(formula::Tree)
    if formula.left.connective == '⊤' || formula.right.connective == '⊤' || areChildrenOppositeAssociativity(formula)
        return Tree('⊤')
    elseif formula.left.connective == '⊥'
        return simplify(formula.right)
    elseif formula.right.connective == '⊥'
        return simplify(formula.left)
    else
        return simplifyChildren(formula)
    end
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

function simplify(formula::Tree)
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

function simplifyLoop(formula::Tree)
    steadystate = deepcopy(formula)
    simplified = simplify(formula)
    while !isEqual(steadystate, simplified)
        steadystate = deepcopy(simplified)
        simplified = simplify(simplified)
    end
    return simplified
end

end #module