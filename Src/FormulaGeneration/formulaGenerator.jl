module FormulaGenerator


include("../Tableau-solver/interface.jl")

using StatsBase
using Distributed
using .Interface

export runGenerator

function makePathIfNotExists(path::String)
    if !isdir(path)
        mkpath(path)
    end
end

function makeFileIfNotExists(path::String)
    if !isfile(path)
        mkpath(path)
    end
end

function generateFormula(maxdepth::Int64, depth::Int64, modal::Int64, prevNeg::Bool)
    symbols = ['∧', '→', '↔', '∧']
    modals = ['◇', '◻']
    neg = ['¬']
    atoms = ['p','q', '⊥','⊤']

    if depth == 1
        choice = sample(atoms)
        leaf = Interface.Tree(choice)
        return leaf 
    else
        possible = symbols
        if maxdepth != depth
            possible = [possible; atoms]
        end
        if !prevNeg
            possible = [possible; neg]
        end
        if modal > 0
            possible = [possible; modals]
        end
        choice = sample(possible)
        root = Interface.Tree(choice)
        if choice in neg
            # neg does not reset the modal depth
            child1 = generateFormula(maxdepth, depth-1, modal, true)
            Interface.addrightchild!(root, child1)
            return root
        elseif choice in modals
            child1 = generateFormula(maxdepth, depth-1, modal-1, false)
            Interface.addrightchild!(root, child1)
            return root
        elseif choice in symbols
            child1 = generateFormula(maxdepth, depth-1, modal, false)
            child2 = generateFormula(maxdepth, depth-1, modal, false)
            while Interface.isEquivalent(child1, child2)
                child2 = generateFormula(maxdepth, depth-1, modal, false)
            end
            Interface.addrightchild!(root, child1)
            Interface.addleftchild!(root, child2)
            return root
        else
            leaf = Interface.Tree(choice)
            return leaf
        end
    end
end

function generateFormulaOfDepth(depth::Int64, maxConseqModal::Int64)
    while true
        f = generateFormula(depth, depth, maxConseqModal, false)
        if Interface.height(f) >= depth
            return f
        end
    end
end

function equivalentOnList(formulas::Vector{String}, formula::Interface.Tree)
    for f in formulas
        if Interface.isEquivalent(Interface.parseFormula(f), formula)
            println(f, " == ", Interface.formula2String(formula))
            return true
        end
    end
    return false
end



# Distributed.addprocs(1)  #we add one worker process that will be the 
#                          #long-running background computation
# wid = workers()[end]     #take last worker (there is just one anyway)
# const result = RemoteChannel(()->Channel{Bool}(1));
# @everywhere function longrun(result,c=3,time=0)
#     #write whatever code you need here
#     for i in 1:c
#         sleep(time)
#         println("Working $i at $(myid())")
#     end
#     #we use the RemoteChannel to collect the result
#     put!(result, (c,time,999999, myid()))
# end

# function ready_or_not(result,wid)
#     if !isready(result)
#         println("Computation at $wid will be terminated")
#         rmprocs(wid)
#         return nothing
#     else
#         return take!(result)
#     end
# end

function runGenerator(amountPerDepth::Int64=1000, minDepth::Int64 = 6, maxDepth::Int64=13, maxConseqModal::Int64=5, path::String = "generatedFormulas")
    #=
        minDepth indicates the minimum depth of a tree of a formula.
        maxDepth indicates the maximum depth of a tree of a formula. It is important to notice that the root node is already depth 1.
        maxConseqModal indicates how many modal symbols can be next to each other
    =#

    makePathIfNotExists(path)

    for d in minDepth:maxDepth
        file = joinpath(path, "depth "*string(d)*".txt")
        formulas = String[]
        open(file, "w") do file
            try1 = 0
            while length(formulas) < amountPerDepth
                try1 = try1 + 1
                formula = generateFormulaOfDepth(d, maxConseqModal)
                formulaString = Interface.formula2String(formula)*"\n"
                println(try1, formulaString)
                step1 = !Interface.isTautOrContInAnyLanguage(formula)
                println(step1)
                step2 = formulaString ∉ formulas
                println(step2)
                step3 = !equivalentOnList(formulas, formula)
                println(step3)
                if !Interface.isTautOrContInAnyLanguage(formula) && formulaString ∉ formulas && !equivalentOnList(formulas, formula)
                    println(formulaString)
                    push!(formulas, formulaString)
                    write(file, formulaString)
                end
            end
        end
    end
end



end #module