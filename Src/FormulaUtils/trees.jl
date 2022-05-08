module Trees

#Maybe a good idea to change pointers to arrays

export Tree, addleftchild!, addrightchild!, replaceleftchild!, replacerightchild!, height, isEqual, isEquivalent, isOpposite, printFormula, formula2String

"""
Inspiration from https://github.com/JuliaCollections/AbstractTrees.jl/blob/master/examples/binarytree_core.jl
"""

mutable struct Tree
    connective::Char
    left::Tree
    right::Tree

    # Root constructor
    Tree(symbol) = new(symbol)
    Tree(symbol, l, r) = new(symbol, l, r)
end

function addleftchild!(parent::Tree, symbol)
    !isdefined(parent, :left) || error("left child is already assigned")
    parent.left = deepcopy(symbol)
end

function addrightchild!(parent::Tree, symbol)
    !isdefined(parent, :right) || error("right child is already assigned")
    parent.right = deepcopy(symbol)
end

function replaceleftchild!(parent::Tree, symbol)
    parent.left = deepcopy(symbol)
end

function replacerightchild!(parent::Tree, symbol)
    parent.right = deepcopy(symbol)
end

function printFormula(formulatree::Tree)
    if formulatree == undef
        print("Ups...")
        return
    end

    if isdefined(formulatree, :left)
        if !isdefined(formulatree.left, :left) || !isdefined(formulatree.left, :right)
            printFormula(formulatree.left)
        else
            print(" (")
            printFormula(formulatree.left)
            print(" )")
        end
    end
    
    print(" ", formulatree.connective)

    if isdefined(formulatree, :right)
        if !isdefined(formulatree.right, :left) || !isdefined(formulatree.right, :right)
            printFormula(formulatree.right)
        else
            print(" (")
            printFormula(formulatree.right)
            print(" )")
        end
    end
end

function formula2String(formulatree::Tree)
    if formulatree == undef
        error("you shouldn't end up here")
        return
    end

    left = ""
    if isdefined(formulatree, :left)
        if !isdefined(formulatree.left, :left) || !isdefined(formulatree.left, :right)
            left = formula2String(formulatree.left)
        else
            left = " (" * formula2String(formulatree.left) * " )"
        end
    end

    middle = " "*formulatree.connective

    right = ""
    if isdefined(formulatree, :right)
        if !isdefined(formulatree.right, :left) || !isdefined(formulatree.right, :right)
            right = formula2String(formulatree.right)
        else
            right = " (" * formula2String(formulatree.right) * " )"
        end
    end
    return left*middle*right
end

function height(tree::Tree)
    # we count the root node.
    lh = 0
    rh = 0

    if isdefined(tree, :left)
        lh = height(tree.left)
    end
    if isdefined(tree, :right)
        rh = height(tree.right)
    end
    return max(lh, rh) + 1
end

function isEquivalent(t1::Tree, t2::Tree)
    #check if formulas are equivalent e.g. A^B and B^A are    
    if !isdefined(t1, :left) && isdefined(t2, :left)
        return false
    end

    if !isdefined(t1, :right) && isdefined(t2, :right)
        return false
    end

    if !isdefined(t2, :left) && isdefined(t1, :left)
        return false
    end

    if !isdefined(t2, :right) && isdefined(t1, :right)
        return false
    end


    # if !isdefined(t1, :left) && !isdefined(t2, :left) && !isdefined(t1, :right) && !isdefined(t2, :right)
    #     return true
    # end

    if t1.connective == t2.connective
        if !isdefined(t1, :left)
            if !isdefined(t1, :right)
                return true
            else
                return isEquivalent(t1.right, t2.right)
            end
        elseif !isdefined(t1, :right)
            # this should never be the case, because either the treenode has two children 
            #   or one child on the right
            return isEquivalent(t1.left, t2.lfet)
        else
            equal = isEquivalent(t1.left, t2.left) && isEquivalent(t1.right, t2.right)
            if !equal && t1.connective in ['∧', '↔', '∧'] # symmetrical connectives
                symmetrical = isEquivalent(t1.left, t2.right) && isEquivalent(t1.right, t2.left)
                return equal || symmetrical
            else
                return equal
            end
        end
    else
        return false
    end
end

function isEqual(t1::Tree, t2::Tree)
    # I am pretty sure this can be simplified but I have no idea how, since you cannot access undefined 
    #checks if two trees are equivalent
    
    #the base cases check that if a child is undefined then it has to be undefined in t2 as well otherwise it is false
    if !isdefined(t1, :left) && isdefined(t2, :left)
        return false
    end

    if !isdefined(t1, :right) && isdefined(t2, :right)
        return false
    end

    if !isdefined(t2, :left) && isdefined(t1, :left)
        return false
    end

    if !isdefined(t2, :right) && isdefined(t1, :right)
        return false
    end


    # if !isdefined(t1, :left) && !isdefined(t2, :left) && !isdefined(t1, :right) && !isdefined(t2, :right)
    #     return true
    # end

    if t1.connective == t2.connective
        if !isdefined(t1, :left)
            if !isdefined(t1, :right)
                return true
            else
                return isEqual(t1.right, t2.right)
            end
        elseif !isdefined(t1, :right)
            return isEqual(t1.left, t2.lfet)
        else
            return isEqual(t1.left, t2.left) && isEqual(t1.right, t2.right)
        end
    else
        return false
    end
end

function isOpposite(t1::Tree, t2::Tree)
    if t1.connective == '¬'
        if t2.connective == '¬'
            return false
        else
            return isEqual(t1.right, t2)
        end
    elseif t2.connective == '¬'
        return isEqual(t1, t2.right)
    else
        return false
    end
end

end # module