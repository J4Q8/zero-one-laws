module Tableaux

export Tableau, addFormula!, printBranch

using ..Trees

mutable struct Tableau
    #keeps track of the current branch
    list::Vector{NamedTuple{(:formula, :world), Tuple{Tree, Int64}}}
    #keeps track of whick rules have been applied
    applied::Vector{Bool}
    #this will keep track of branches to be explored
    branches::Vector{NamedTuple{(:formula, :world, :line), Tuple{Tree, Int64, Int64}}}
    #keeps track of relations
    relations::Vector{NamedTuple{(:i, :j, :line), Tuple{Int64, Int64, Int64}}}

    #root constructor
    Tableau() = new(NamedTuple{(:formula, :world), Tuple{Tree, Int64}}[], Bool[], NamedTuple{(:formula, :world, :line), Tuple{Tree, Int64, Int64}}[], NamedTuple{(:i, :j, :line), Tuple{Int64, Int64, Int64}}[])
end

function addFormula!(tableau::Tableau, formula::Tree, world::Int64)
    tuple1 = (formula = formula, world = world)
    push!(tableau.list, tuple1)
    push!(tableau.applied, false)
end

function printBranch(tableau::Tableau)
    for (idx, l) in enumerate(tableau.list)
        print(idx,":\t")
        printFormula(l.formula)
        print(", ", l.world, "\t\t")
        for r in tableau.relations
            if r.line == idx
                print(r.i,"r",r.j,", ")                
            end    
        end   
        print("\n") 
    end
end

end #module