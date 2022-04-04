module Interface

include("cleaner.jl")
include("trees.jl")
include("parser.jl")
include("tableau.jl")
include("propositionalRules.jl")
#include("solver.jl")

using .Trees
using .Parser
# using .Tableau
# using .PropositionalRules
# using .Solver

export startSolver

function startSolver()
    println("Loading premises")

    initlist = NamedTuple{(:formula, :world, :applied), Tuple{Tree, Int32, Bool}}[]

    for line in eachline("IN_premises.txt")
        try
            formula = parseFormula(line)
            ttuple = (formula = formula, world = 0, applied = false)
            push!(initlist, ttuple)
        catch
            error(line, " :cannot be parsed")
        end
    end
    
    println("Loading consequent")
    io = open("IN_consequent.txt", "r");
    consequent = read(io, String)

    try
        formula = parseFormula(consequent)
        negformula = Tree('¬')
        addrightchild!(negformula, formula)
        ttuple = (formula = negformula, world = 0, applied = false)
        push!(initlist, ttuple)
    catch
        error(consequent, " :cannot be parsed")
    end
    close(io)

    tableau = Tableau(initlist)
end

end