module Structures

using ..Trees

export KRModel

mutable struct KRModel
    #initialize worlds
    worlds::Vector{Vector{Dict{Tree, Char}}} # needs to be like this because otherwise we will have sparse matrix

    #initialize relations
    r12::BitMatrix
    r23::BitMatrix
    r13::BitMatrix #transitivity

    #Root constructor
    KRModel(worlds, R12, R23) = new(worlds, R12, R23, getTransitiveClosure(R12, R23))
end

function getTransitiveClosure(R12::BitMatrix, R23::BitMatrix)
    R13 = falses(size(R12)[1], size(R23)[2])
    for row in 1:size(R12)[1], col in 1:size(R23)[2]
        if R12[row,col]
            for col2 in 1:size(R23)[2]
                if R23[col,col2]
                    R13[row, col2] = true
                end
            end
        end
    end
    return R13
end

end #module