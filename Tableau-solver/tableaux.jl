module Tableaux

export Tableau, printBranch

using ..Trees

mutable struct Tableau
    #keeps track of the current branch
    list::Vector{NamedTuple{(:formula, :world), Tuple{Tree, Int32}}}
    #keeps track of whick rules have been applied
    applied::Vector{Bool}
    #this will keep track of branches to be explored
    branches::Vector{NamedTuple{(:formula, :world, :line), Tuple{Tree, Int32, Int32}}}
    #keeps track of relations
    relations::Vector{NamedTuple{(:i, :j, :line), Tuple{Int32, Int32, Int32}}}

    #root constructor
    Tableau() = new(NamedTuple{(:formula, :world), Tuple{Tree, Int32}}[], Vector{Char}, NamedTuple{(:formula, :world, :line), Tuple{Tree, Int32, Int32}}[], NamedTuple{(:i, :j, :line), Tuple{Int32, Int32, Int32}}[])
end

function addFormula!(tableau::Tableau, formula::Tree, world::Int32)
    tuple1 = (formula = formula, world = world)
    push!(tableau.list, tuple1)
    push!(tableau.applied, false)
end

function printBranch(tableau::Tableau)
    for (idx, l) in enumerate(tableau.list)
        print(idx,":\t")
        printFormula(l)
        print(", ", l.world, "\t")
        for r in tableau.relations
            if r.line == idx
                print(r.i,"R",r.j,", ")                
            end    
        end   
        print("\n") 
    end
end

end #module