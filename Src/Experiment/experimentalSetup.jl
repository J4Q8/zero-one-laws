module ExperimentalSetup

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

export runExperiment

function writeResultsData(rFile::IOStream, results::Vector{Float64})
    rData = string(results[1])
    for r in results[2:end]
        rData = rData*", "*string(r)
    end

    write(rFile, rData*"\n")
end

function runExperiment(language::String, n::Int64, formulaSet::Int64, nModels::Int64 = 5000, nFrames::Int64 = 500, nValuations::Int64 = 50)

    formulaRange = 6:13
    formulaPath = joinpath("..", joinpath("..", joinpath("generated", "formulas "*string(formulaSet))))
    # VScode path
    # formulaPath = joinpath("generated", "formulas "*string(formulaSet))
    resultsPath = joinpath("..", joinpath("..", joinpath(language, joinpath(string(n), "formulas "*string(formulaSet)))))
    # VScode path
    # resultsPath = joinpath("validated-Peregrine", joinpath(language, joinpath(string(n), "formulas "*string(formulaSet))))

    if !isdir(resultsPath)
        mkpath(resultsPath)
    end

    for r in formulaRange
        formulaFile = joinpath(formulaPath, "depth "*string(r)*".txt")
        resultsFile = joinpath(resultsPath, "depth "*string(r)*".txt")

        open(formulaFile, "r") do fFile
            for formula in eachline(fFile)

                #convert formula to tree
                formula = parseFormula(formula)

                #check formula in models and frames
                st_time_model = time_ns()
                modelCount = serialCheckModelValidity(formula, language, n, nModels)
                elapsed_time_model = (time_ns() - st_time_model)/1e9

                st_time_frame = time_ns()
                frameCount = serialCheckFrameValidity(formula, language, n, nValuations, nFrames)
                elapsed_time_frame = (time_ns() - st_time_frame)/1e9

                results = [modelCount, nModels, elapsed_time_model, frameCount, nFrames, nValuations, elapsed_time_frame]

                open(resultsFile, "a") do rFile
                    writeResultsData(rFile, results)
                end

            end
        end
    end
    


end

function prepareJobArrayScripts(languages::Vector{String} = ["gl", "k4", "s4"], nodes::Vector{Int64} = collect(40:8:80), formulaSets::Vector{Int64} = collect(1:10))
    path = joinpath("Src", "Experiment")

    count = 0
    for f in formulaSets, l in languages, n in nodes

        count = count+1
        file = joinpath(path, "experiment"*string(count)*".jl")

        open(file, "w") do io
            incl = """include("experimentalSetup.jl")\n\n"""
            use = "using .ExperimentalSetup\n\n"
            command = "runExperiment(\"" * l *"\", "*string(n)*", "*string(f)*")\n"
            write(io, incl*use*command)
        end
    end
end

# prepareJobArrayScripts()

end #module