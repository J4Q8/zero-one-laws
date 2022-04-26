module FormulaGenerator

include("../FormulaUtils/cleaner.jl")
include("../FormulaUtils/trees.jl")
include("../FormulaUtils/parser.jl")
include("../Tableau-solver/interface.jl")

using .Trees
using .Parser
using .Interface

function runGenerator(amountPerDepth::Int64=1000, minDepth::Int64 = 6, maxDepth::Int64=13, maxConseqModal::Int64=5, path::String = "../../generatedFormulas")
    #=
        minDepth indicates the minimum depth of a tree of a formula.
        maxDepth indicates the maximum depth of a tree of a formula. It is important to notice that the root node is already depth 1.
        maxConseqModal indicates how many modal symbols can be next to each other
    =#

    makePathIfNotExists(path)

    for d in minDepth:maxDepth

        while length() < amountPerDepth
            formula = generateFormula()
            if !isTautOrContInAnyLanguage(formula)
            end

        end

    end

end

function makePathIfNotExists(path::String)
    if !isdir(path)
        makepath(path)
    end
end

function isTautology(formula::Tree, constrains::String)
    return validate("", formula, constrains)
end

function isContradiction(formula::Tree, constrains::String)
    return validate(formula, "", constrains)
end

function isTautOrCont(formula::Tree, constrains::String)
    return isTautology(formula, constrains) || isContradiction(formula, constrains)
end

function isTautOrContInAnyLanguage(formula::Tree)
    languages = ["gl","s4","k4"]
    for l in languages
        if isTautOrCont(formula, l)
            return true
        end
    end
    return false
end



end #module