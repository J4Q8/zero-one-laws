module Interface

include("../FormulaUtils/cleaner.jl")
include("../FormulaUtils/trees.jl")
include("../FormulaUtils/parser.jl")
include("../FormulaUtils/simplifier.jl")
include("tableaux.jl")
include("propositionalRules.jl")
include("modalRules.jl")
include("solver.jl")

using .Trees
using .Parser
using .Tableaux
using .Solver
using .Simplifier

export runSolver, validate, isTautology, isContradiction, isTautOrCont, isTautOrContInAnyLanguage

function welcomeGetConstraints()
    println("Welcome to Jakub's modal tableaux solver!")

    restrictions = Char[]

    while true
        println("Which modal language would you like to use? (gl, s4, k4, custom):")

        language = readline()

        if language == "gl"
            push!(restrictions, 'c')
            push!(restrictions, 't')
        elseif language == "s4"
            push!(restrictions, 't')
            push!(restrictions, 'r')
        elseif language == "k4"
            push!(restrictions, 't')
        elseif language == "custom"
            println("Which constraints would you like to impose on the language? (You can choose multiple ones, provide a string)")
            println("transitivity : t, reflexivity : r, symmetry : s, converse well-foundedness : c")
            possible = ['t', 'r', 's', 'c']
            given = readline()
            for c in given
                if c in possible
                    push!(restrictions, c)
                else
                    println("Unrecognized constraint: ", c, " ignored")
                end
            end
        else
            println("Incorrect input")
            continue
        end
        break
    end
    return restrictions
end

function parseConstraints(constraint::String)
    restrictions = Char[]
    if constraint == "gl"
        push!(restrictions, 'c')
        push!(restrictions, 't')
    elseif constraint == "s4"
        push!(restrictions, 't')
        push!(restrictions, 'r')
    elseif constraint == "k4"
        push!(restrictions, 't')
    else
        possible = ['t', 'r', 's', 'c']
        for l in constraint
            if l in possible
                push!(restrictions, l)
            end
        end
    end
    return restrictions
end

function addPremise!(tableau::Tableau, formula::Tree)
    addFormula!(tableau, formula, 0)
end

function parseAndAddPremise!(tableau::Tableau, formula::String, mode::Int64 = 1)
    if !isempty(formula)
        try
            formula = parseFormula(formula)
            addPremise!(tableau, formula)
            if mode == 1
                printFormula(formula)
                print("\n")
            end
        catch
            error(formula, " :cannot be parsed")
        end
    end
end

function addConsequent!(tableau::Tableau, formula::Tree)
    negformula = Tree('¬')
    addrightchild!(negformula, formula)
    addFormula!(tableau, negformula, 0)
end

function parseAndAddConsequent!(tableau::Tableau, formula::String, mode::Int64 = 1)
    if !isempty(formula)
        try
            formula = parseFormula(formula)
            addConsequent!(tableau, formula)
            if mode == 1
                printFormula(formula)
                print("\n")
            end
        catch
            error(formula, " :cannot be parsed")
        end
    end
end

function loadPremisesConsequent(premisesPATH::String, consequentPATH::String)

    tableau = Tableau()

    println("Loading premises from ", premisesPATH)

    for line in eachline(premisesPATH)
        parseAndAddPremise!(tableau, line)
    end
    
    println("Loading consequent from ", consequentPATH)

    io = open(consequentPATH, "r");
    consequent = read(io, String)
    parseAndAddConsequent!(tableau, consequent)
    close(io)
    
    return tableau
end

function runSolver(premisesPATH::String = "Src/Tableau-solver/IN_premises.txt", consequentPATH::String = "Src/Tableau-solver/IN_consequent.txt")

    constraints = welcomeGetConstraints()

    tableau = loadPremisesConsequent(premisesPATH, consequentPATH)

    @time @allocated begin
    solve!(tableau, constraints)
    end
end

function validate(premise::String = "", consequent::String = "", constraints::String = "")
    constraintsCharVec = parseConstraints(constraints)
    tableau = Tableau()
    parseAndAddPremise!(tableau, premise, 2)
    parseAndAddConsequent!(tableau, consequent, 2)
    
    return solve!(tableau, constraintsCharVec, 2)
end

function validate(;premise::Tree = Tree('~'), consequent::Tree = Tree('~'), constraints::String = "")
    constraintsCharVec = parseConstraints(constraints)
    tableau = Tableau()
    if premise.connective != '~'
        addPremise!(tableau, premise)
    end
    if consequent.connective != '~'
        addConsequent!(tableau, consequent)
    end
    return solve!(tableau, constraintsCharVec, 2)
end

function isTautology(formula::Tree, constrains::String)
    return Interface.validate(consequent=formula, constraints=constrains)
end

function isContradiction(formula::Tree, constrains::String)
    return Interface.validate(premise=formula,constraints = constrains)
end

function isTautOrCont(formula::Tree, constrains::String)
    return isTautology(formula, constrains) || isContradiction(formula, constrains)
end

function isTautOrContInAnyLanguage(formula::Tree)
    languages = ["gl","s4","k4"]
    for l in languages
        if isTautOrCont(formula, l)
            return true
        end
    end
    return false
end

end #module