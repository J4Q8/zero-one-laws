module Interface

include("cleaner.jl")
include("trees.jl")
include("parser.jl")
include("tableaux.jl")
include("propositionalRules.jl")
include("modalRules.jl")
include("solver.jl")

using .Trees
using .Parser
using .Tableaux
using .Solver

export runSolver, validate

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

function addPremise!(tableau::Tableau, formula::String, mode::Int64 = 1)
    if !isempty(formula)
        try
            formula = parseFormula(formula)
            addFormula!(tableau, formula, 0)
            if mode == 1
                printFormula(formula)
                print("\n")
            end
        catch
            error(formula, " :cannot be parsed")
        end
    end
end

function addConsequent!(tableau::Tableau, formula::String, mode::Int64 = 1)
    if !isempty(formula)
        try
            formula = parseFormula(formula)
            negformula = Tree('¬')
            addrightchild!(negformula, formula)
            addFormula!(tableau, negformula, 0)
            if mode == 1
                printFormula(formula)
                print("\n")
            end
        catch
            error(formula, " :cannot be parsed")
        end
    end
end

function loadPremisesConsequent()

    tableau = Tableau()

    println("Loading premises from 'IN_premises.txt'")

    for line in eachline("IN_premises.txt")
        addPremise!(tableau, line)
    end
    
    println("Loading consequent from 'IN_consequent.txt'")

    io = open("IN_consequent.txt", "r");
    consequent = read(io, String)
    addConsequent!(tableau, consequent)
    close(io)
    
    return tableau
end

function runSolver()

    constraints = welcomeGetConstraints()

    tableau = loadPremisesConsequent()

    @time @allocated begin
    solve!(tableau, constraints)
    end
end

function validate(premise::String, consequent::String, constraints::String = "")
    constraintsCharVec = parseConstraints(constraints)
    tableau = Tableau()
    addPremise!(tableau, premise, 2)
    addConsequent!(tableau, consequent, 2)
    return solve!(tableau, constraintsCharVec, 2)
end

end #module