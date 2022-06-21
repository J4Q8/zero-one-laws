include(joinpath("..", joinpath("Src", joinpath("FormulaUtils","trees.jl"))))
include(joinpath("..", joinpath("Src", joinpath("FormulaUtils","cleaner.jl"))))
include(joinpath("..", joinpath("Src", joinpath("FormulaUtils","parser.jl"))))
include(joinpath("..", joinpath("Src", joinpath("FormulaUtils","simplifier.jl"))))
include(joinpath("..", joinpath("Src", joinpath("ModelChecking","structures.jl"))))
include(joinpath("..", joinpath("Src", joinpath("ModelChecking","modelChecker.jl"))))

using .Trees
using .Parser
using .Simplifier
using .Structures
using .ModelChecker


function equivalentOnList(formulas::Vector{Tree}, formula::Tree)
    #we want to check for equivalences not identities
    for f in formulas
        if isEquivalent(f, formula)
            return true
        end
    end
    return false
end

function getAllTC!()
    formulas = Tree[]
    metadata = String[]
    formulaSetRange = 1:10
    count = 0

    for formulaSet in formulaSetRange
        formulaPath = joinpath("generated", "formulas "*string(formulaSet))
        metaPath = joinpath("generated", "metaData "*string(formulaSet))
        formulaFile = joinpath(formulaPath, "tripleTC.txt")
        metaFile = joinpath(metaPath, "tripleTC.txt")

        mF = open(metaFile, "r")
        mData = readlines(mF, keep = true)
        close(mF)
        
        open(formulaFile, "r") do io
            for (i, line) in enumerate(eachline(io))
                formula = parseFormula(line)
                if equivalentOnList(formulas, formula)
                    continue
                end
                push!(formulas, formula)

                open(metaFile, "r") do io2
                    push!(metadata, mData[i])
                end
                count = count + 1
            end
        end
    end
    println("There were "*string(count)*" TCs in total but only "*string(length(formulas))*" were unique.")
    return formulas, metadata
end

function saveTC(formulas::Vector{Tree}, metadata::Vector{String})
    saveFormulaPath = joinpath("generated", "TC")
    saveMetaPath = joinpath("generated", "TC")

    if !isdir(saveFormulaPath)
        mkpath(saveFormulaPath)
    end

    if !isdir(saveMetaPath)
        mkpath(saveMetaPath)
    end

    saveFormulaFile = joinpath(saveFormulaPath, "TC.txt")
    saveMetaFile = joinpath(saveMetaPath, "metaData TC.txt")

    open(saveFormulaFile, "w") do io
        for f in formulas
            fString = formula2String(f)
            write(io, fString*"\n")
        end
    end

    open(saveMetaFile, "w") do io2
        for m in metadata
            write(io2, m)
        end
    end
    println("All Tc were saved.")
end

formulas, metadata = getAllTC!()
saveTC(formulas, metadata)