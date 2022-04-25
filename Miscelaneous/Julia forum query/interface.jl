module Interface

export foo

include("parser.jl")
include("trees.jl")
#include("solver.jl")
using .Parser
using .Trees

function foo(a::Char = 'a')
    initlist = Tree[]
    push!(initlist, parseFormula(a))
end

end #module