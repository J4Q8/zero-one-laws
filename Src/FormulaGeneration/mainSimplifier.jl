
include(joinpath("..", joinpath("FormulaUtils","trees.jl")))
include(joinpath("..", joinpath("FormulaUtils","cleaner.jl")))
include(joinpath("..", joinpath("FormulaUtils","parser.jl")))
include(joinpath("..", joinpath("FormulaUtils","simplifier.jl")))

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