module Tableaus

export Tableau

using ..Trees

mutable struct Tableau
    #keeps track of the current branch
    list::Vector{NamedTuple{(:formula, :world, :applied), Tuple{Tree, Int32, Bool}}}
    #this will keep track of branches to be explored
    branches::Vector{NamedTuple{(:formula, :world, :line), Tuple{Tree, Int32, Int32}}}
    #keeps track of relations
    relations::Vector{NamedTuple{(:i, :j, :line), Tuple{Int32, Int32, Int32}}}

    #root constructor
    Tableau(initiallist) = new(initiallist)
end

end #module