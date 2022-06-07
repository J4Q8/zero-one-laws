
include("trees.jl")
include("cleaner.jl")
include("parser.jl")
include("simplifier.jl")

using .Trees
using .Parser
using .Simplifier

while true
    println("Type formula to simplify: ")
    line = readline()
    formula = parseFormula(line)
    println("Parsed formula: ", formula2String(formula))
    println("Simplified formula: ", formula2String(simplify(formula)))
    println()
end