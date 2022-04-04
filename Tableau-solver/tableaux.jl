module Tableaux

export Tableau, printBranch

using ..Trees

mutable struct Tableau
    #keeps track of the current branch
    list::Vector{NamedTuple{(:formula, :world, :applied), Tuple{Tree, Int32, Bool}}}
    #this will keep track of branches to be explored
    branches::Vector{NamedTuple{(:formula, :world, :line), Tuple{Tree, Int32, Int32}}}
    #keeps track of relations
    relations::Vector{NamedTuple{(:i, :j, :line), Tuple{Int32, Int32, Int32}}}

    #root constructor
    Tableau(initiallist) = new(initiallist, NamedTuple{(:formula, :world, :line), Tuple{Tree, Int32, Int32}}[], NamedTuple{(:i, :j, :line), Tuple{Int32, Int32, Int32}}[])
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