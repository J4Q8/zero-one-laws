module KRStructures

using ..Trees
using LinearAlgebra
using Random: bitrand

export KRStructure, generateFrame, generateModel, addRandomValuations!

mutable struct KRStructure
    #initialize worlds
    worlds::Vector{Vector{Dict{Tree, Char}}} # needs to be like this because otherwise we will have sparse matrix

    #initialize relations
    r12::BitMatrix
    r23::BitMatrix
    r13::BitMatrix #transitivity

    class::String

    #Root constructor
    KRStructure(worlds, R12, R23, class) = new(worlds, R12, R23, getTransitiveClosure(R12, R23), class)
end

function getTransitiveClosure(R12::BitMatrix, R23::BitMatrix)
    # yes it is just matrix multiplication!!! wow, no seriously im so happy I realised that!
    return (R12*R23) .> 0
end

function generateFrame(n::Int64, language::String)
    # n is a total number of states layers will have n/4, n/2, n/4 elements
    m = floor(Int, n/4)

    r12 = bitrand(m, 2m)
    # first layer points cannot be endpoints
    while !minimum(maximum.(eachrow(r12))) || !minimum(maximum.(eachcol(r12)))
        r12 = bitrand(m, 2m)
    end

    r23 = bitrand(2m, m)
    # neither can be those in second layer
    while !minimum(maximum.(eachrow(r23))) || !minimum(maximum.(eachcol(r23)))
        r23 = bitrand(2m, m)
    end

    worlds = Vector{Dict{Tree, Char}}[]
    for layer in [m, 2m, m]
        push!(worlds, vec([Dict{Tree, Char}() for _ in 1:layer]))
    end

    return KRStructure(worlds, r12, r23, language)
end

function addRandomValuations!(frame::KRStructure)
    for (idx, layer) in enumerate(frame.worlds), idx2 in 1:length(layer)
        valuation = bitrand(2)

        p = Tree('p')
        frame.worlds[idx][idx2][p] = valuation[1] ? '⊤' : '⊥' 

        q = Tree('q')
        frame.worlds[idx][idx2][q] = valuation[2] ? '⊤' : '⊥' 
    end
end

function generateModel(n::Int64, language::String)
    frame = generateFrame(n, language)
    addRandomValuations!(frame)
    return frame
end

end #module