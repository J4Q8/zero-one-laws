include(joinpath("..", joinpath("FormulaUtils","trees.jl")))
include(joinpath("..", joinpath("FormulaUtils","cleaner.jl")))
include(joinpath("..", joinpath("FormulaUtils","parser.jl")))
include(joinpath("..", joinpath("FormulaUtils","simplifier.jl")))
include(joinpath("..", joinpath("ModelChecking","structures.jl")))
include(joinpath("..", joinpath("ModelChecking","specializedModelChecker.jl")))

using .Trees
using .Parser
using .Simplifier
using .Structures
using .SpecializedModelChecker

function runExperiment(language::String, n::Int64)
    range = (6, 13)
    formulaPath = joinpath("..", joinpath("..", joinpath("generated", "formulas")))
end