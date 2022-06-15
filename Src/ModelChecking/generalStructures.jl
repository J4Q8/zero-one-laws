module GeneralStructures

using ..Trees
using LinearAlgebra
using Random: bitrand
using LightGraphs

#transitiveclosure!
# .|| -> or of matrices
# diagm for diagonal matrix
# transpose
#  neighbors(G,5)

export GeneralStructure, generateRandomFrame, generateFrame, generateModel, addRandomValuations!

mutable struct GeneralStructure
    frame::DiGraph
    worlds::Vector{Dict{Tree, Char}}
end

function generateRandomFrame(nStates::Int64, language::String = nothing)
    G = bitrand((nStates, nStates))
    if language == "s4"
        applyTransitiveClosure!(G)
        applyReflexivity!(G)
    elseif language == "k4"
        applyTransitiveClosure!(G)
    elseif language == "gl"
        applyTransitiveClosure!(G)
        makeIrreflexive!(G)
        makeConverseWellFounded!(G)
    end

    worlds = vec([Dict{Tree, Char}() for _ in 1:n])

    G = DiGraph(G)

    return GeneralStructure(G, worlds)
end

function generateFrame(n::Int64, language::String)
    # generates KR frame

    # n is a total number of states layers will have n/4, n/2, n/4 elements
    m = floor(Int, n/4)
    G = falses(n, n)

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

    G[1:m, m+1:3m] .= G[1:m, m+1:3m] .|| r12
    G[m+1:3m, 3m+1:4m] .= G[m+1:3m, 3m+1:4m] .|| r23

    # this is faster for large matrices (e.g. ~10x faster for n = 80) than transitiveclosure!()
    r13 = (r12*r23) .> 0
    G[1:m,3m+1:4m] .= G[1:m,3m+1:4m] .|| r13

    #add reflexivity and random reflexivity
    if language == "s4"
        applyReflexivity!(G)
    elseif language == "k4"
        applyReflexivity!(G, true)
    end

    worlds = vec([Dict{Tree, Char}() for _ in 1:n])

    G = DiGraph(G)

    return GeneralStructure(G, worlds)
end

function generateModel(n::Int64, language::String)
    # again KR model
    frame = generateFrame(n, language)
    addRandomValuations!(frame)
    return frame
end

function applyReflexivity!(mat::BitMatrix, sparse::Bool = false)
    n = size(mat)[1]
    if sparse
        mat[diagind(mat)] = bitrand(n)
    else
        mat[diagind(mat)] .= true
    end
end

function applyTransitiveClosure!(structure::GeneralStructure)
    transitiveclosure!(structure.frame, true)
end

function makeIrreflexive!(mat::BitMatrix)
    mat[diagind(mat)] .= false
end

function makeCWFRec!(mat::BitMatrix, row::Int64, depth::Int64 = 0)
    cols = findall(mat[row])
    depth = depth + 1
    if depth > 3
        mat[row, col] .= false
        depth = 0
    end
    for col in cols
        makeCWFRec!(mat, col, depth)
    end
end

function makeConverseWellFounded!(mat::BitMatrix)
    n = size(mat)[1, 1:end]
    for i in 1:n
        makeCWFRec!(mat, is)
    end
end

function addRandomValuations!(frame::GeneralStructure, atoms::Vector{Char} = ['p', 'q'])
    for idx in 1:length(frame.worlds)
        valuation = bitrand(length(atoms))
        for (v, atom) in enumerate(atoms)
            root = Tree(atom)
            frame.worlds[idx][root] = valuation[v] ? '⊤' : '⊥' 
        end
    end
end

end #module