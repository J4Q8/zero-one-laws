
include("../FormulaUtils/trees.jl")
include("../FormulaUtils/cleaner.jl")
include("../FormulaUtils/parser.jl")
include("../FormulaUtils/simplifier.jl")

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