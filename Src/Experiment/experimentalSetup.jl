module ExperimentalSetup

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

export runExperiment, finishExperiment, runAsymptoticModelExperiment, runSelectedFormulasExperiment

function writeResultsData(rFile::IOStream, results::Vector{Float64})
    rData = string(results[1])
    for r in results[2:end]
        rData = rData*", "*string(r)
    end

    write(rFile, rData*"\n")
end

function processFormula(formula::String, resultsFile::String, language::String, n::Int64, nModels::Int64, nFrames::Int64, nValuations::Int64, infiniteProperties::Bool = true)
    #convert formula to tree
    formula = parseFormula(formula)

    #check formula in models and frames
    st_time_model = time_ns()
    modelCount = serialCheckModelValidity(formula, language, n, nModels, infiniteProperties)
    elapsed_time_model = (time_ns() - st_time_model)/1e9

    st_time_frame = time_ns()
    frameCount = serialCheckFrameValidity(formula, language, n, nValuations, nFrames, infiniteProperties)
    elapsed_time_frame = (time_ns() - st_time_frame)/1e9

    results = [modelCount, nModels, elapsed_time_model, frameCount, nFrames, nValuations, elapsed_time_frame]

    open(resultsFile, "a") do rFile
        writeResultsData(rFile, results)
    end
end

function processFormulaInAsymptoticModel(formula::String, resultsFile::String, language::String)
    #convert formula to tree
    formula = parseFormula(formula)

    #check formula in models and frames
    model = getAsymptoticModel(language)
    result = checkModelValidity!(model, formula)

    open(resultsFile, "a") do rFile
        write(rFile, string(result)*"\n")
    end
end

function runExperiment(language::String, n::Int64, formulaSet::Int64, infiniteProperties::Bool = true, nModels::Int64 = 5000, nFrames::Int64 = 500, nValuations::Int64 = 50)

    formulaRange = 6:13
    formulaPath = joinpath("..", joinpath("..", joinpath("generated", "formulas "*string(formulaSet))))
    # VScode path
    # formulaPath = joinpath("generated", "formulas "*string(formulaSet))
    resultsPath = joinpath("..", joinpath("..", joinpath("validated-Peregrine", joinpath(language, joinpath(string(n), "formulas "*string(formulaSet))))))
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
                processFormula(formula, resultsFile, language, n, nModels, nFrames, nValuations, infiniteProperties)
            end
        end
    end
end

function getNumberOfValidatedFormulas(file::String)
    if !isfile(file)
        return 0
    end
    open(file, "r") do io
        lines = readlines(io)
    end
    lines = [i for i in lines if i != ""]
    return length(lines)
end

function finishExperiment(language::String, nodes::Int64, formulaSet::Int64, infiniteProperties::Bool, nModels::Int64 = 5000, nFrames::Int64 = 500, nValuations::Int64 = 50)
    formulaRange = 6:13
    formulaPath = joinpath("..", joinpath("..", joinpath("generated", "formulas "*string(formulaSet))))
    # VScode path
    # formulaPath = joinpath("generated", "formulas "*string(formulaSet))

    resultsPath = joinpath("..", joinpath("..", joinpath("validated-Peregrine", joinpath(language, joinpath(string(nodes), "formulas "*string(formulaSet))))))
    # VScode path
    # resultsPath = joinpath("validated-Peregrine", joinpath(language, joinpath(string(nodes), "formulas "*string(formulaSet))))

    if !isdir(resultsPath)
        mkpath(resultsPath)
    end

    for r in formulaRange
        formulaFile = joinpath(formulaPath, "depth "*string(r)*".txt")
        resultsFile = joinpath(resultsPath, "depth "*string(r)*".txt")

        n = getNumberOfValidatedFormulas(resultsFile)
        if n == 100
            continue
        end

        open(formulaFile, "r") do fFile
            for (i, formula) in enumerate(eachline(fFile))
                if i <= n
                    continue
                end

                processFormula(formula, resultsFile, language, nodes, nModels, nFrames, nValuations, infiniteProperties)
            end
        end
    end
end

function runSelectedFormulasExperiment(language::String, n::Int64, infiniteProperties::Bool = true, nModels::Int64 = 5000, nFrames::Int64 = 500, nValuations::Int64 = 50)
    
    selectedFile = joinpath("..", joinpath("..", "SelectedFormulasRaw.txt"))
    # VScode path
    # selectedFile = "SelectedFormulasRaw.txt"

    resultsPath = joinpath("..", joinpath("..", joinpath("validated-Peregrine", joinpath(language, joinpath(string(n), "formulas 0")))))
    # VScode path
    # resultsPath = joinpath("validated-Peregrine", joinpath(language, joinpath(string(n), "formulas 0")))

    resultsFile = joinpath(resultsPath, "selected.txt")

    if !isdir(resultsPath)
        mkpath(resultsPath)
    end

    open(selectedFile, "r") do sFile
        for formula in eachline(sFile)
            processFormula(formula, resultsFile, language, n, nModels, nFrames, nValuations, infiniteProperties)
        end
    end
end

function runAsymptoticModelExperiment(languages::Vector{String} = ["gl", "k4", "s4"])
    
    formulaSetRange = 1:10
    formulaRange = 6:13

    selectedFile = joinpath("..", joinpath("..", "SelectedFormulasRaw.txt"))
    # VScode path
    selectedFile = "SelectedFormulasRaw.txt"

    for language in languages
        for formulaSet in formulaSetRange, r in formulaRange

            formulaPath = joinpath("..", joinpath("..", joinpath("generated", "formulas "*string(formulaSet))))
            # VScode path
            formulaPath = joinpath("generated", "formulas "*string(formulaSet))

            resultsPath = joinpath("..", joinpath("..", joinpath("asymptoticModelExperiment", joinpath(language, "formulas "*string(formulaSet)))))
            # VScode path
            resultsPath = joinpath("asymptoticModelExperiment", joinpath(language, "formulas "*string(formulaSet)))

            formulaFile = joinpath(formulaPath, "depth "*string(r)*".txt")
            resultsFile = joinpath(resultsPath, "depth "*string(r)*".txt")

            if !isdir(resultsPath)
                mkpath(resultsPath)
            end

            open(formulaFile, "r") do fFile
                for formula in eachline(fFile)
                    processFormulaInAsymptoticModel(formula, resultsFile, language)
                end
            end
        end
        # just the selected formulas
        resultsPath = joinpath("..", joinpath("..", joinpath("asymptoticModelExperiment", joinpath(language, "selected.txt"))))
        # VScode path
        resultsPath = joinpath("asymptoticModelExperiment", joinpath(language, "formulas 0"))

        if !isdir(resultsPath)
            mkpath(resultsPath)
        end

        resultsFile = joinpath(resultsPath, "selected.txt")

        open(selectedFile, "r") do sFile
            for formula in eachline(sFile)
                processFormulaInAsymptoticModel(formula, resultsFile, language)
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

function prepareJobArrayScriptsContinued(languages::Vector{String} = ["k4", "s4"], nodes::Vector{Int64} = collect(40:8:80), formulaSets::Vector{Int64} = collect(1:10))
    path = joinpath("Src", "Experiment")

    count = 0
    for f in formulaSets, l in languages, n in nodes

        count = count+1
        file = joinpath(path, "finishExperiment"*string(count)*".jl")

        open(file, "w") do io
            incl = """include("experimentalSetup.jl")\n\n"""
            use = "using .ExperimentalSetup\n\n"
            command = "finishExperiment(\"" * l *"\", "*string(n)*", "*string(f)*")\n"
            write(io, incl*use*command)
        end
    end
end

function prepareJobArrayScriptsSelected(languages::Vector{String} = ["gl", "k4", "s4"], nodes::Vector{Int64} = collect(40:8:80))
    path = joinpath("Src", "Experiment")

    count = 0
    for l in languages, n in nodes

        count = count+1
        file = joinpath(path, "selectedExperiment"*string(count)*".jl")

        open(file, "w") do io
            incl = """include("experimentalSetup.jl")\n\n"""
            use = "using .ExperimentalSetup\n\n"
            command = "runSelectedFormulasExperiment(\"" * l *"\", "*string(n)*")\n"
            write(io, incl*use*command)
        end
    end
end

# prepareJobArrayScripts()
# prepareJobArrayScriptsContinued()
# prepareJobArrayScriptsSelected()

end #module