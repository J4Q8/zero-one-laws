include(joinpath("..", joinpath("FormulaUtils","trees.jl")))
include(joinpath("..", joinpath("FormulaUtils","cleaner.jl")))
include(joinpath("..", joinpath("FormulaUtils","parser.jl")))
include(joinpath("..", joinpath("FormulaUtils","simplifier.jl")))
include(joinpath("..", joinpath("ModelChecking","structures.jl")))
include(joinpath("..", joinpath("ModelChecking","modelChecker.jl")))

using .Trees
using .Parser
using .Simplifier
using .Structures
using .ModelChecker

formulaSetRange = 1:10

formulas = Tree[]
metadata = String[]

for formulaSer in formulaSetRange
    formulaPath = joinpath("generated", "formulas "*string(formulaSet))
    formulaPath = joinpath("generated", "metaData "*string(formulaSet))
    formulaFile = joinpath(formulaPath, "tripleTC.txt")
    metaFile = joinpath(formulaPath, "tripleTC.txt")

    open(formulaFile, "r") do io
        for line in eachline(io)
            formula = parseFormula(line)
            if formula
        end
    end

end