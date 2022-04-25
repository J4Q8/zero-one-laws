module Parser

export parseFormula

include("trees.jl")

using .Trees

function parseFormula(a::Char)
    return Tree(a)
end

end #module