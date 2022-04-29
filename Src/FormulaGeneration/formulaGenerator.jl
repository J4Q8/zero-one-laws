module FormulaGenerator


include("../Tableau-solver/interface.jl")

using StatsBase
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


function isTautology(formula::Interface.Tree, constrains::String)
    return Interface.validate(consequent=formula, constraints=constrains)
end

function isContradiction(formula::Interface.Tree, constrains::String)
    return Interface.validate(premise=formula,constraints = constrains)
end

function isTautOrCont(formula::Interface.Tree, constrains::String)
    return isTautology(formula, constrains) || isContradiction(formula, constrains)
end

function isTautOrContInAnyLanguage(formula::Interface.Tree)
    languages = ["gl","s4","k4"]
    for l in languages
        if isTautOrCont(formula, l)
            return true
        end
    end
    return false
end

function isListed(file::IOStream, formulaString::String)
    for line in readlines(file, keep=true)
        if formulaString == line
            return true
        end
    end
    return false
end

function isEquivalent(formula1::Interface.Tree, formula2::Interface.Tree)
    #check if formulas are equivalent e.g. A^B and B^A are    
end

function generateFormula(depth::Int64, modal::Int64, prevNeg::Bool)
    symbols = ['∧', '→', '↔', '∧']
    modals = ['◇', '◻']
    neg = ['¬']
    atoms = ['p','q', '⊥','⊤']

    if depth == 1
        choice = sample(atoms)
        leaf = Interface.Tree(choice)
        return leaf 
    else
        possible = [symbols; atoms]
        if !prevNeg
            possible = hcat(possible, neg)
        end
        if modal > 0
            possible = hcat(possible, modals)
        end
        choice = sample(possible)
        root = Interface.Tree(choice)
        if choice in neg
            # neg does not reset the modal depth
            child1 = generateFormula(depth-1, modal, true)
            Interface.addrightchild!(root, child1)
            return root
        elseif choice in modal
            child1 = generateFormula(depth-1, modal+1, false)
            Interface.addrightchild!(root, child1)
            return root
        elseif choice in symbols
            child1 = generateFormula(depth-1, 0, false)
            child2 = generateFormula(depth-1, 0, false)
            while isEquivalent(child1, child2)
                child2 = generateFormula(depth-1, 0, false)
            end
            Interface.addrightchild!(root, child1)
            Interface.addleftchild!(root, child2)
            return root
        else
            leaf = Interface.Tree(choice)
            return leaf
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
            while length(formulas) < amountPerDepth
                formula = generateFormula(d, 0, false)
                # check if formula has desired length

                formulaString = Interface.formula2String(formula)*"\n"
                if !isTautOrContInAnyLanguage(formula) && formulaString ∉ formulas
                    push!(formulas, formulaString)
                    write(file, formulaString)
                end
            end
        end
    end
end



end #module