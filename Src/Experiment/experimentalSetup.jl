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

    formulaRange = 6:13
    formulaPath = joinpath("..", joinpath("..", joinpath("generated", "formulas")))
    resultsPath = joinpath("..", joinpath("..", joinpath("validated-Peregrine", joinpath(language, string(n)))))


    if !isdir(resultsPath)
        mkpath(resultsPath)
    end

    for r in formulaRange
        formulaFile = joinpath(formulaPath, "depth "*string(d)*".txt")
        resultsFile = joinpath(resultsPath, "depth "*string(d)*".txt")

        open(formulaFile, "r") do fFile
            for formula in eachline(fFile)
                #check formula in models and frames
                open(resultsFile, "a") do rFile
                    #save the results
                end
            end
        end
    end
    


end