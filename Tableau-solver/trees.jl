module Trees

export Tree, addleftchild!, addrightchild!, height

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

#to be implemented: height of a tree

function height(tree::Tree)
    # don't count the root node
    lh = -1
    rh = -1

    if isdefined(tree, :left)
        lh = height(tree.left)
    end
    if isdefined(tree, :rigth)
        rh = height(tree.right)
    end
    return max(lh, rh) + 1
end
end