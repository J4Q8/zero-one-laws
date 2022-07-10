module FormulaGenerator

include(joinpath("..", joinpath("Tableau-solver","interface.jl")))

using .Interface
using StatsBase

export runGenerator

CONNECTIVES = ['∧', '→', '↔', '∨']
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

function generateFormulaTrivial(depth::Int64, modal::Int64, banned::Vector{Char} = ATOMS)

    if depth == 1
        choice = sample(ATOMS)
        leaf = Interface.Tree(choice)
        return leaf 
    else
        possible = [CONNECTIVES; ATOMS]
        possible = [possible; NEG]
        if modal > 0
            possible = [possible; MODALS]
        end
        setdiff!(possible, banned)
        choice = sample(possible)
        root = Interface.Tree(choice)
        if choice in NEG
            # neg does not reset the modal depth, neg T and neg F do not make sense
            child1 = generateFormula(depth-1, modal, true, Char[])
            Interface.addrightchild!(root, child1)
            return root
        elseif choice in MODALS
            child1 = generateFormula(depth-1, modal-1, false, Char[])
            Interface.addrightchild!(root, child1)
            return root
        elseif choice in CONNECTIVES
            child1 = generateFormula(depth-1, modal, false, Char[])
            child2 = generateFormula(depth-1, modal, false, Char[])
            Interface.addleftchild!(root, child1)
            Interface.addrightchild!(root, child2)
            return root
        else
            leaf = Interface.Tree(choice)
            return leaf
        end
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
            # neg does not reset the modal depth, neg T and neg F do not make sense
            child1 = generateFormula(depth-1, modal, true, ['⊥','⊤'])
            Interface.addrightchild!(root, child1)
            return Interface.simplify(root)
        elseif choice in MODALS
            child1 = generateFormula(depth-1, modal-1, false, Char[])
            Interface.addrightchild!(root, child1)
            return Interface.simplify(root)
        elseif choice in CONNECTIVES
            leftban, rightban = getBanned(choice)
            child1 = generateFormula(depth-1, modal, false, leftban)
            child2 = generateFormula(depth-1, modal, false, rightban)
            while Interface.isEquivalent(child1, child2)
                child2 = generateFormula(depth-1, modal, false, rightban)
            end
            Interface.addleftchild!(root, child1)
            Interface.addrightchild!(root, child2)
            return Interface.simplify(root)
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

function generateFormulaOfDepth(depth::Int64, maxConseqModal::Int64, nonTrivial::Bool = true)
    while true
        if nonTrivial
            f = generateFormula(depth, maxConseqModal, false)
        else
            f = generateFormulaTrivial(depth, maxConseqModal, false)
        end

        if Interface.height(f) >= depth
            return f
        end
    end
end

function equivalentOnList(formulas::Vector{String}, formula::Interface.Tree)
    #we want to check for equivalences not identities
    for f in formulas
        if Interface.isEquivalent(Interface.parseFormula(f), formula)
            # println(f, " == ", Interface.formula2String(formula))
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
    return results
    
end

function writeMetaData(metaFile::IOStream, res::Vector{Bool}, depth::Int64 = -1)
    metaData = string(res[1])
    for r in res[2:end]
        metaData = metaData*", "*string(r)
    end

    #if depth is -1 do not save it, if depth was passed, do save it
    if depth != -1
        metaData = metaData*", "*string(depth)
    end

    write(metaFile, metaData*"\n")
end

function getPrevFormulas(curBatch::Int64, depth::Int64, path::String)
    formulas = String[]
    for b in 1:curBatch
        formulaPath = joinpath(path, "formulas "*string(b))
        formulaFile = joinpath(formulaPath, "depth "*string(depth)*".txt")
        if isfile(formulaFile)
            open(formulaFile, "r") do io
                formulas = [formulas; readlines(io, keep=true)]
            end
        else
            return formulas
        end
    end
    return formulas
end

function generateFormulas(number::Int64, depth::Int64, maxModalDepth::Int64, nonTrivial::Bool)
    formulas = Interface.Tree[]
    for n in 1:number
        formula = generateFormulaOfDepth(depth, maxModalDepth, nonTrivial)
        while formula ∈ formulas
            formula = generateFormulaOfDepth(depth, maxModalDepth, nonTrivial)
        end
        push!(formulas, formula)
    end
end

function runGenerator(nBatches::Int64 = 1, amountPerDepth::Int64=1000, minDepth::Int64 = 6, maxDepth::Int64=13, maxConseqModal::Int64=5, path::String = "generated")
    #=
        minDepth indicates the minimum depth of a tree of a formula.
        maxDepth indicates the maximum depth of a tree of a formula. It is important to notice that the root node is already depth 1.
        maxConseqModal indicates how many modal symbols can be next to each other
    =#
    for b in 1:nBatches

        formulaPath = joinpath(path, "formulas "*string(b))
        metaDataPath = joinpath(path, "metaData "*string(b))

        if isdir(formulaPath)
            continue
        end

        makePathIfNotExists(formulaPath)
        makePathIfNotExists(metaDataPath)

        
        extraFormulasFile = joinpath(formulaPath, "tripleTC.txt")
        extraMetaFile = joinpath(metaDataPath, "tripleTC.txt")

        for d in minDepth:maxDepth

            formulasFile = joinpath(formulaPath, "depth "*string(d)*".txt")
            metaFile = joinpath(metaDataPath, "depth "*string(d)*".txt")

            formulas = getPrevFormulas(b, d, path)
            open(formulasFile, "w") do formulasFile
                open(metaFile, "w") do metaFile

                    while length(formulas) < amountPerDepth*b

                        formula = generateFormulaOfDepth(d, maxConseqModal)
                        formulaString = Interface.formula2String(formula)*"\n"
                        res = timeLimitedTautOrContALL(formula)

                        # return nothing if a formula is Taut or Cont in all three languages
                        if isnothing(res)
                            continue
                        elseif count(res) == 3
                            #write formulas that were all taut or cont
                            open(extraFormulasFile, "a") do io
                                write(io, formulaString)
                            end
                            open(extraMetaFile, "a") do io
                                writeMetaData(io, res, d)
                            end
                            continue
                        end

                        if !equivalentOnList(formulas, formula)
                            println(formulaString)
                            push!(formulas, formulaString)
                            write(formulasFile, formulaString)
                            writeMetaData(metaFile, res)
                        end
                    end
                end
            end
        end
    end
end

function getSelectedFormulasMetaData()
    selectedFormulaFile = "SelectedFormulasRaw.txt"
    selectedFormulaMetaFile = "SelectedFormulasMetaData.txt"

    open(selectedFormulaFile, "r") do io
        selectedFormulas = readlines(io)
        print
        for formula in selectedFormulas
            formula = Interface.parseFormula(formula)
            res = timeLimitedTautOrContALL(formula)
            # return nothing if a formula is Taut or Cont in all three languages
            if isnothing(res)
                open(selectedFormulaMetaFile, "a") do io
                    write(io, ",,,,,\n")
                end
            else
                open(selectedFormulaMetaFile, "a") do io
                    writeMetaData(io, res)
                end
                continue
            end
        end
    end
end

getSelectedFormulasMetaData()

end #module
