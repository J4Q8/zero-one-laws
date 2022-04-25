module FormulaGenerator

include("../Formulas/cleaner.jl")
include("../Formulas/trees.jl")
include("../Formulas/parser.jl")
include("../Tableau-solver/interface.jl")

using .Trees
using .Parser
using .Interface

function runGenerator(amountPerDepth::Int64=1000, minDepth::Int64 = 6, maxDepth::Int64=13, maxConseqModal::Int64=5, path::String)
    #=
        minDepth indicates the minimum depth of a tree of a formula.
        maxDepth indicates the maximum depth of a tree of a formula. It is important to notice that the root node is already depth 1.
        maxConseqModal indicates how many modal symbols can be next to each other
    =#

    for d in minDepth:maxDepth
        for i in 1:amountPerDepth
            formula = generateFormula()
            isTautOrCont(formula)
            

        end

    end

end

function isTautology(formula::Tree)
    validate
end

function isContradiction(formula::Tree)

end

function isTautOrCont(formula::Tree)
    return isTautology(formula) || isContradiction(formula)
end



end #module