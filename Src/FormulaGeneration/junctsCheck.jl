include(joinpath("..", joinpath("FormulaUtils","trees.jl")))
include(joinpath("..", joinpath("FormulaUtils","cleaner.jl")))
include(joinpath("..", joinpath("FormulaUtils","parser.jl")))
include(joinpath("..", joinpath("FormulaUtils","simplifier.jl")))

using .Trees
using .Parser
using .Simplifier


function getRepeatingJuncts(juncts::Vector{Tree})
    repeating = Vector{Int64}[]
    for (idx1, junct1) in enumerate(juncts[1:end-1])
        for (idx2, junct2) in enumerate(juncts[idx1+1:end])
            if isEquivalent(junct1, junct2)
                #add to list of repeating formulas
                added = false
                for r in repeating
                    if idx1 ∈ r 
                        added = true
                        if idx1+idx2 ∉ r
                            push!(r, idx1+idx2)
                        end
                    end
                end
                if !added
                    push!(repeating, [idx1, idx1+idx2])  
                end              
            end
        end
    end
    return repeating
end

function reduceRepeatingJuncts(juncts::Vector{Tree})
    repeating = getRepeatingJuncts(juncts)
    println(juncts)
    # remove repeating formulas
    toDelete = Int64[]
    for r in repeating
        toDelete = [toDelete; r[2:end]]
    end
    deleteat!(juncts, sort(toDelete))
    # recreate tree structure using juncts
    return juncts
end


juncts = [Tree('a'), Tree('b'), Tree('c'), Tree('b'), Tree('b'), Tree('c'), Tree('a')]

rjuncts = getRepeatingJuncts(juncts)
println(rjuncts)

println(reduceRepeatingJuncts(juncts))