module FormulaGenerator

include("../Tableau-solver/interface.jl")
using .Interface
using StatsBase

export runGenerator

CONNECTIVES = ['∧', '→', '↔', '∧']
MODALS = ['◇', '◻']
NEG = ['¬']
ATOMS = ['p','q', '⊥','⊤']

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

function simplifyChildren(formula::Interface.Tree)
    connective = Interface.Tree(formula.connective)
    if isdefined(formula, :left)
        Interface.addleftchild!(connective, simplify(formula.left))
    end
    if isdefined(formula, :right)
        Interface.addrightchild!(connective, simplify(formula.right))
    end
    return connective
end

function simplifyConj(formula::Interface.Tree)
    if formula.left.connective == '⊥' || formula.right.connective == '⊥' || Interface.isOpposite(formula.left, formula.right)
        return Interface.Tree('⊥')
    elseif formula.left.connective == '⊤'
        return simplify(formula.right)
    elseif formula.right.connective == '⊤'
        return simplify(formula.left)
    else
        return simplifyChildren(formula)
    end
end

function simplifyImp(formula::Interface.Tree)
    if formula.left.connective == '⊥'
        return Interface.Tree('⊤') 
    elseif formula.right.connective == '⊤'
        return Interface.Tree('⊤')
    elseif formula.left.connective == '⊤' && formula.right.connective == '⊥'
        return Interface.Tree('⊥') 
    else
        return simplifyChildren(formula)
    end
end

function simplifyBiImp(formula::Interface.Tree)
    if Interface.isEquivalent(formula.left, formula.right)
        return Interface.Tree('⊤')
    elseif formula.left.connective == '¬' && Interface.isEquivalent(formula.left.right, formula.right)
        return Interface.Tree('⊥')
    elseif formula.right.connective == '¬' && Interface.isEquivalent(formula.right.right, formula.left)
        return Interface.Tree('⊥')
    elseif formula.left.connective == '⊥' && formula.right.connective == '⊤'
        return Interface.Tree('⊥')
    elseif formula.right.connective == '⊥' && formula.left.connective == '⊤'
        return Interface.Tree('⊥')
    else
        return simplifyChildren(formula)
    end
end

function simplifyDisj(formula::Interface.Tree)
    if formula.left.connective == '⊤' || formula.right.connective == '⊤' || Interface.isOpposite(formula.left, formula.right)
        return Interface.Tree('⊤')
    elseif formula.left.connective == '⊥'
        return simplify(formula.right)
    elseif formula.right.connective == '⊥'
        return simplify(formula.left)
    else
        return simplifyChildren(formula)
    end
end

function simplifyNeg(formula::Interface.Tree)
    if formula.right.connective == '¬'
        return simplify(formula.right.right)
    elseif formula.right.connective == '⊥'
        Interface.Tree('⊤')
    elseif formula.right.connective == '⊤'
        Interface.Tree('⊥')
    else
        return simplifyChildren(formula)
    end
end

function simplifyDia(formula::Interface.Tree)
    if formula.right.connective == '⊥'
        return Interface.Tree('⊥')
    else
        return simplifyChildren(formula)
    end
end

function simplifyBox(formula::Interface.Tree)
    if formula.right.connective == '⊤'
        return Interface.Tree('⊤')
    else
        return simplifyChildren(formula)
    end
end

function simplify(formula::Interface.Tree)
    if formula.connective == '∧'
        return simplifyConj(formula)
    elseif formula.connective == '→'
        return simplifyImp(formula)
    elseif formula.connective == '↔'
        return simplifyBiImp(formula)
    elseif formula.connective == '∨'
        return simlifyDisj(formula)
    elseif formula.connective == '¬'
        return simplifyNeg(formula)
    elseif formula.connective == '◇'
        return simplifyDia(formula)
    elseif formula.connective == '◻'
        return simplifyBox(formula)
    else
        return formula
    end
end

function simplifyLoop(formula::Interface.Tree)
    steadystate = deepcopy(formula)
    simplified = simplify(formula)
    while !Interface.isEqual(steadystate, simplified)
        steadystate = deepcopy(simplified)
        simplified = simplify(simplified)
    end
    return simplified
end

function getBanned(connective::Char)
    if connective == '∧'
        return ['⊥','⊤'], ['⊥','⊤']
    elseif connective == '→'
        return ['⊥'], ['⊤']
    elseif connective == '↔'
        return Char[], Char[]
    elseif connective == '∨'
        return ['⊥','⊤'], ['⊥','⊤']
    else
        return Char[], Char[]
    end
end

function generateFormula(depth::Int64, modal::Int64, prevNeg::Bool, banned::Vector{Char} = ATOMS)

    if depth == 1
        choice = sample(ATOMS)
        leaf = Interface.Tree(choice)
        return leaf 
    else
        possible = [CONNECTIVES; ATOMS]
        if !prevNeg
            possible = [possible; NEG]
        end
        if modal > 0
            possible = [possible; MODALS]
        end
        setdiff!(possible, banned)
        choice = sample(possible)
        root = Interface.Tree(choice)
        if choice in NEG
            # neg does not reset the modal depth
            child1 = generateFormula(depth-1, modal, true, Char[])
            Interface.addrightchild!(root, child1)
            return simplifyLoop(root)
        elseif choice in MODALS
            child1 = generateFormula(depth-1, modal-1, false, Char[])
            Interface.addrightchild!(root, child1)
            return simplifyLoop(root)
        elseif choice in CONNECTIVES
            leftban, rightban = getBanned(choice)
            child1 = generateFormula(depth-1, modal, false, leftban)
            child2 = generateFormula(depth-1, modal, false, rightban)
            while Interface.isEquivalent(child1, child2)
                child2 = generateFormula(depth-1, modal, false, rightban)
            end
            Interface.addleftchild!(root, child1)
            Interface.addrightchild!(root, child2)
            return simplifyLoop(root)
        else
            leaf = Interface.Tree(choice)
            return leaf
        end
    end
end

function generateFormulaOld(maxdepth::Int64, depth::Int64, modal::Int64, prevNeg::Bool)
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
        f = generateFormula(depth, maxConseqModal, false)
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


function checkTC(formula::Interface.Tree, language::String)
    isTaut = Interface.isTautology(formula, language)
    if isnothing(isTaut)
        return nothing
    elseif isTaut
        #if something is a tautology it cannot be a contradiction
        return (isTaut, false)
    else
        isCont = Interface.isContradiction(formula, language)
        if isnothing(isCont)
            return nothing
        else
            return (isTaut, isCont)
        end
    end
    


    if !isnothing(isTaut) && isTaut
        return (isTaut, false)
    else
        isCont = Interface.isContradiction(formula, language)
        return (isTaut, isCont)
    end
end

function timeLimitedTautOrContALL(formula::Interface.Tree)
    languages = ["gl","s4","k4"]

    results = Bool[]
    for l in languages
        res = checkTC(formula, l)
        if isnothing(res)
            return nothing
        else
            push!(results, res[1])
            push!(results, res[2])
        end
    end
    # return nothing if a formula is Taut or Cont in all three languages
    if count(results) == 3
        return nothing
    else
        return results
    end
end

function runGenerator(amountPerDepth::Int64=1000, minDepth::Int64 = 6, maxDepth::Int64=13, maxConseqModal::Int64=5, path::String = "generated")
    #=
        minDepth indicates the minimum depth of a tree of a formula.
        maxDepth indicates the maximum depth of a tree of a formula. It is important to notice that the root node is already depth 1.
        maxConseqModal indicates how many modal symbols can be next to each other
    =#
    formulaPath = joinpath(path, "formulas")
    metaDataPath = joinpath(path, "metaData")
    makePathIfNotExists(formulaPath)
    makePathIfNotExists(metaDataPath)
    

    for d in minDepth:maxDepth
        formulasFile = joinpath(formulaPath, "depth "*string(d)*".txt")
        metaFile = joinpath(metaDataPath, "depth "*string(d)*".txt")
        formulas = String[]
        open(formulasFile, "w") do formulasFile
            open(metaFile, "w") do metaFile

                while length(formulas) < amountPerDepth

                    formula = generateFormulaOfDepth(d, maxConseqModal)
                    formulaString = Interface.formula2String(formula)*"\n"
                    res = timeLimitedTautOrContALL(formula)

                    if isnothing(res) # true if time limit was exceeded
                        continue
                    end

                    if !equivalentOnList(formulas, formula)
                        println(formulaString)
                        push!(formulas, formulaString)
                        write(formulasFile, formulaString)

                        metaData = string(res[1])
                        for r in res[2:end]
                            metaData = metaData*", "*string(r)
                        end
                        write(metaFile, metaData*"\n")
                    end
                end
            end
        end
    end
end

end #module
