module Trees

export Tree, addleftchild!, addrightchild!

"""
Inspiration from https://github.com/JuliaCollections/AbstractTrees.jl/blob/master/examples/binarytree_core.jl
"""

mutable struct Tree
    connective::Char
    left::Tree
    right::Tree

    # Root constructor
    Tree(symbol) = new(symbol)
end

function addleftchild!(parent::Tree, symbolnode)
    !isdefined(parent, :left) || error("left child is already assigned")
    parent.left = symbolnode
end

function addrightchild!(parent::Tree, symbolnode)
    !isdefined(parent, :right) || error("right child is already assigned")
    parent.right = symbolnode
end

#to be implemented: height of a tree, in-order traversal

end