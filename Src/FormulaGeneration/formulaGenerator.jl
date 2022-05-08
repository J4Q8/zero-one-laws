module FormulaGenerator

using StatsBase
using Distributed

addprocs(1)
const result = RemoteChannel(()->Channel{Tuple}(1));

include("../Tableau-solver/interface.jl")
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


function checkTC(result, formula::Interface.Tree, language::String)
    # eval(Expr(:using,:Interface))
    println("yay-1")
    isTaut = Interface.isTautology(formula, language)
    if isTaut
        put!(result, (isTaut, false))
    else
        isCont = Interface.isContradiction(formula, language)
        put!(result, (isTaut, isCont))
    end
end

function timeLimitedTautOrCont(formula::Interface.Tree, language::String)
    TIMELIMIT = 40

    wid = workers()[end]

    startTime = time_ns()
    println("yay")
    remote_do(checkTC, wid, result, formula, language)
    println("yay2")
    while true
        #check if ready
        if isready(result)
            return take!(result)
        else
            # check if running for more than given time limit
            endTime = time_ns()
            # println("yay_",(endTime - startTime)*1e-9)
            if (endTime - startTime)*1e-9 > TIMELIMIT
                interrupt(wid)
                println("time limit exceeded --- killing the proccess")
                return nothing
            end
        end
    end
end

function timeLimitedTautOrContALL(formula::Interface.Tree)
    languages = ["gl","s4","k4"]

    results = Bool[]
    for l in languages
        res = timeLimitedTautOrCont(formula, l)
        if isnothing(res)
            return nothing
        else
            put!(results, res[1])
            put!(results, res[2])
        end
    end
    # return nothing if a formula is Taut or Cont in all three languages
    if count(results) == 3
        return nothing
    else
        return results
    end
end

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

                res = timeLimitedTautOrContALL(formula)

                if isnothing(res)
                    continue
                end

                if !equivalentOnList(formulas, formula)
                    println(formulaString)
                    push!(formulas, formulaString)
                    write(file, formulaString)
                end
            end
        end
    end
end

end #module
