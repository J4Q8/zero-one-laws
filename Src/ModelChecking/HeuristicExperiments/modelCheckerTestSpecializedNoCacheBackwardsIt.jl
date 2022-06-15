
include(joinpath("..", joinpath("..", joinpath("FormulaUtils","trees.jl"))))
include(joinpath("..", joinpath("..", joinpath("FormulaUtils","cleaner.jl"))))
include(joinpath("..", joinpath("..", joinpath("FormulaUtils","parser.jl"))))
include(joinpath("..", joinpath("..", joinpath("FormulaUtils","simplifier.jl"))))
include(joinpath("..", "KRstructures.jl"))
include("specializedModelCheckerNoCacheBackwardIt.jl")

using Test
using .Trees
using .Parser
using .Simplifier
using .KRStructures
using .SpecializedModelChecker


function isValidModel(formula::String, language::String = "gl")
    formula = parseFormula(formula)
    for _ in 1:100
        model = generateModel(80, language)
        if !checkModelValidity!(model, formula)
            return false
        end
    end
    return true
end

function isValidFrame(formula::String, language::String = "gl")
    formula = parseFormula(formula)
    for _ in 1:100
        model = generateFrame(80, language)
        if !checkFrameValidity(model, formula, 50)
            return false
        end
    end
    return true
end

@time begin
    @testset verbose = true "ModelCheckerTest" begin

        @testset "Propositional tautologies" begin
            @test isValidModel("( p ↔ q ) ↔ ( ¬ p ↔ ¬ q )") == true
            @test isValidFrame("( p ↔ q ) ↔ ( ¬ p ↔ ¬ q )") == true
            @test isValidModel("( ( p → q ) ∧ ( p → q ) ) → ( p → ( q ∧ q ) )") == true
            @test isValidFrame("( ( p → q ) ∧ ( p → q ) ) → ( p → ( q ∧ q ) )") == true
            @test isValidModel("( p ↔ q ) ↔ ( ¬ p ↔ ¬ q )") == true
            @test isValidFrame("( p ↔ q ) ↔ ( ¬ p ↔ ¬ q )") == true
            @test isValidModel("(p ^ q) -> (p V q)") == true
            @test isValidFrame("(p ^ q) -> (p V q)") == true
        end
    
        @testset "Propositional contradictions" begin
            @test isValidModel("¬(( p ↔ q ) ↔ ( ¬ p ↔ ¬ q ))") == false
            @test isValidFrame("¬(( p ↔ q ) ↔ ( ¬ p ↔ ¬ q ))") == false
            @test isValidModel("¬(( ( p → q ) ∧ ( p → q ) ) → ( p → ( q ∧ q ) ))") == false
            @test isValidFrame("¬(( ( p → q ) ∧ ( p → q ) ) → ( p → ( q ∧ q ) ))") == false
            @test isValidModel("¬(( p ↔ q ) ↔ ( ¬ p ↔ ¬ q ))") == false
            @test isValidFrame("¬(( p ↔ q ) ↔ ( ¬ p ↔ ¬ q ))") == false
            @test isValidModel("¬((p ^ q) -> (p V q))") == false
            @test isValidFrame("¬((p ^ q) -> (p V q))") == false
        end
    
        @testset "Modal tautologies" begin
            @test isValidModel("◇ ( p ∧ q ) → ( ◇ p ∧ ◇ q )") == true
            @test isValidFrame("◇ ( p ∧ q ) → ( ◇ p ∧ ◇ q )") == true
            @test isValidModel("◻ p → p", "s4") == true
            @test isValidFrame("◻ p → p", "s4") == true
            @test isValidModel("◻ p → ◻ ◻ p", "s4") == true
            @test isValidFrame("◻ p → ◻ ◻ p", "s4") == true
            @test isValidModel("◻ p → ◻ ◻ p", "k4") == true
            @test isValidFrame("◻ p → ◻ ◻ p", "k4") == true
            @test isValidModel("( ◻ p ∨ ◻ q ) ↔ ◻ ( ◻ p ∨ ◻ q )", "s4") == true
            @test isValidFrame("( ◻ p ∨ ◻ q ) ↔ ◻ ( ◻ p ∨ ◻ q )", "s4") == true
            @test isValidModel("◻ ( ◻ ( p ↔ q ) → q ) → ( ◻ ( p ↔ q ) → ◻ q )", "s4") == true
            @test isValidFrame("◻ ( ◻ ( p ↔ q ) → q ) → ( ◻ ( p ↔ q ) → ◻ q )", "s4") == true
            @test isValidModel("◻ p → ◻ ◻ p") == true
            @test isValidFrame("◻ p → ◻ ◻ p") == true
            @test isValidModel("◻ ( ◻ p → p ) → ◻p") == true
            @test isValidFrame("◻ ( ◻ p → p ) → ◻p") == true
            @test isValidModel("◇ p → ¬ ⊥") == true
            @test isValidFrame("◇ p → ¬ ⊥") == true
            @test isValidModel("◻ ( ◇ ⊥ → ( p ∧ p ) )") == true
            @test isValidFrame("◻ ( ◇ ⊥ → ( p ∧ p ) )") == true
            @test isValidModel("◻ ( ◻ p → p ) → ◻ p") == true
            @test isValidFrame("◻ ( ◻ p → p ) → ◻ p") == true
            @test isValidModel("( ( ( ( ( ◻ ( ◻ p ∨ ◻ ◇ ¬ p ) ∨ ◇ ◻ ⊥ ) ∨ ◇ ( ◻ p ∧ ◇ ◇ ¬ p ) ) ∨ ◇ ( ◻ ◇ p ∧ ◇ ◇ ◻ ¬ p ) ) ∨ ◇ ( ◻ p ∧ ◻ ¬ p ) ) ∨ ◇ ( ◻ ( ◻ ¬ p ∨ p ) ∧ ◇ ◇ ( ◇ p ∧ ¬ p ) ) ) ∨ ◇ ( ◻ ( ◇ ¬ p ∨ p ) ∧ ◇ ◇ ( ◻ p ∧ ¬ p ) )") == true
            @test isValidFrame("( ( ( ( ( ◻ ( ◻ p ∨ ◻ ◇ ¬ p ) ∨ ◇ ◻ ⊥ ) ∨ ◇ ( ◻ p ∧ ◇ ◇ ¬ p ) ) ∨ ◇ ( ◻ ◇ p ∧ ◇ ◇ ◻ ¬ p ) ) ∨ ◇ ( ◻ p ∧ ◻ ¬ p ) ) ∨ ◇ ( ◻ ( ◻ ¬ p ∨ p ) ∧ ◇ ◇ ( ◇ p ∧ ¬ p ) ) ) ∨ ◇ ( ◻ ( ◇ ¬ p ∨ p ) ∧ ◇ ◇ ( ◻ p ∧ ¬ p ) )") == true
        end
    
        @testset "Modal contradictions" begin
            @test isValidModel("¬(◇ ( p ∧ q ) → ( ◇ p ∧ ◇ q ))") == false
            @test isValidFrame("¬(◇ ( p ∧ q ) → ( ◇ p ∧ ◇ q ))") == false
            @test isValidModel("¬(◻ p → p)") == false
            @test isValidFrame("¬(◻ p → p)") == false
            @test isValidModel("¬(◻ p → ◻ ◻ p)", "s4") == false
            @test isValidFrame("¬(◻ p → ◻ ◻ p)", "s4") == false
            @test isValidModel("¬(◻ p → ◻ ◻ p)", "k4") == false
            @test isValidFrame("¬(◻ p → ◻ ◻ p)", "k4") == false
            @test isValidModel("¬(( ◻ p ∨ ◻ q ) ↔ ◻ ( ◻ p ∨ ◻ q ))", "s4") == false
            @test isValidFrame("¬(( ◻ p ∨ ◻ q ) ↔ ◻ ( ◻ p ∨ ◻ q ))", "s4") == false
            @test isValidModel("¬(◻ ( ◻ ( p ↔ q ) → p ) → ( ◻ ( p ↔ q ) → ◻ p ))", "s4") == false
            @test isValidFrame("¬(◻ ( ◻ ( p ↔ q ) → p ) → ( ◻ ( p ↔ q ) → ◻ p ))", "s4") == false
            @test isValidModel("¬(◻ p → ◻ ◻ p)") == false
            @test isValidFrame("¬(◻ p → ◻ ◻ p)") == false
            @test isValidModel("¬(◻ ( ◻ p → p ) → ◻p)") == false
            @test isValidFrame("¬(◻ ( ◻ p → p ) → ◻p)") == false
            @test isValidModel("¬(◇ p → ¬ ⊥)") == false
            @test isValidFrame("¬(◇ p → ¬ ⊥)") == false
            @test isValidModel("¬(◻ ( ◇ ⊥ → ( p ∧ p ) ))") == false
            @test isValidFrame("¬(◻ ( ◇ ⊥ → ( p ∧ p ) ))") == false
            @test isValidModel("¬(◻ ( ◻ p → p ) → ◻ p)") == false
            @test isValidFrame("¬(◻ ( ◻ p → p ) → ◻ p)") == false
            @test isValidModel("¬(( ( ( ( ( ◻ ( ◻ p ∨ ◻ ◇ ¬ p ) ∨ ◇ ◻ ⊥ ) ∨ ◇ ( ◻ p ∧ ◇ ◇ ¬ p ) ) ∨ ◇ ( ◻ ◇ p ∧ ◇ ◇ ◻ ¬ p ) ) ∨ ◇ ( ◻ p ∧ ◻ ¬ p ) ) ∨ ◇ ( ◻ ( ◻ ¬ p ∨ p ) ∧ ◇ ◇ ( ◇ p ∧ ¬ p ) ) ) ∨ ◇ ( ◻ ( ◇ ¬ p ∨ p ) ∧ ◇ ◇ ( ◻ p ∧ ¬ p ) ))") == false
            @test isValidFrame("¬(( ( ( ( ( ◻ ( ◻ p ∨ ◻ ◇ ¬ p ) ∨ ◇ ◻ ⊥ ) ∨ ◇ ( ◻ p ∧ ◇ ◇ ¬ p ) ) ∨ ◇ ( ◻ ◇ p ∧ ◇ ◇ ◻ ¬ p ) ) ∨ ◇ ( ◻ p ∧ ◻ ¬ p ) ) ∨ ◇ ( ◻ ( ◻ ¬ p ∨ p ) ∧ ◇ ◇ ( ◇ p ∧ ¬ p ) ) ) ∨ ◇ ( ◻ ( ◇ ¬ p ∨ p ) ∧ ◇ ◇ ( ◻ p ∧ ¬ p ) ))") == false
        end

        @testset "Randomly generated modal tautologies" begin
            # line 26 in tripleTC.txt
            @test isValidModel(" ¬ ( ( ◇ ⊤ ↔ q ) ∨ ◇ p ) ∨ ( ( ( p ∨ q ) ↔ ¬ p ) → q )") == true
            @test isValidFrame(" ¬ ( ( ◇ ⊤ ↔ q ) ∨ ◇ p ) ∨ ( ( ( p ∨ q ) ↔ ¬ p ) → q )") == true
            @test isValidModel(" ¬ ( ( ◇ ⊤ ↔ q ) ∨ ◇ p ) ∨ ( ( ( p ∨ q ) ↔ ¬ p ) → q )", "k4") == true
            @test isValidFrame(" ¬ ( ( ◇ ⊤ ↔ q ) ∨ ◇ p ) ∨ ( ( ( p ∨ q ) ↔ ¬ p ) → q )", "k4") == true
            @test isValidModel(" ¬ ( ( ◇ ⊤ ↔ q ) ∨ ◇ p ) ∨ ( ( ( p ∨ q ) ↔ ¬ p ) → q )", "s4") == true
            @test isValidFrame(" ¬ ( ( ◇ ⊤ ↔ q ) ∨ ◇ p ) ∨ ( ( ( p ∨ q ) ↔ ¬ p ) → q )", "s4") == true
            # line 39 in tripleTC.txt
            @test isValidModel("◻ ⊥ → ◻ ( ( ◻ ◻ q ∨ p ) ∧ q )") == true
            @test isValidFrame("◻ ⊥ → ◻ ( ( ◻ ◻ q ∨ p ) ∧ q )") == true
            @test isValidModel("◻ ⊥ → ◻ ( ( ◻ ◻ q ∨ p ) ∧ q )", "k4") == true
            @test isValidFrame("◻ ⊥ → ◻ ( ( ◻ ◻ q ∨ p ) ∧ q )", "k4") == true
            @test isValidModel("◻ ⊥ → ◻ ( ( ◻ ◻ q ∨ p ) ∧ q )", "s4") == true
            @test isValidFrame("◻ ⊥ → ◻ ( ( ◻ ◻ q ∨ p ) ∧ q )", "s4") == true
            # line 43 in tripleTC.txt
            @test isValidModel("( ◇ p → ◻ q ) ∨ ( p → ( ( ¬ p ∨ ◻ ⊥ ) → ( ¬ ( q ∧ ◻ ⊥ ) ∨ ( p ∧ ( ◻ q → q ) ) ) ) )") == true
            @test isValidFrame("( ◇ p → ◻ q ) ∨ ( p → ( ( ¬ p ∨ ◻ ⊥ ) → ( ¬ ( q ∧ ◻ ⊥ ) ∨ ( p ∧ ( ◻ q → q ) ) ) ) )") == true
            @test isValidModel("( ◇ p → ◻ q ) ∨ ( p → ( ( ¬ p ∨ ◻ ⊥ ) → ( ¬ ( q ∧ ◻ ⊥ ) ∨ ( p ∧ ( ◻ q → q ) ) ) ) )", "k4") == true
            @test isValidFrame("( ◇ p → ◻ q ) ∨ ( p → ( ( ¬ p ∨ ◻ ⊥ ) → ( ¬ ( q ∧ ◻ ⊥ ) ∨ ( p ∧ ( ◻ q → q ) ) ) ) )", "k4") == true
            @test isValidModel("( ◇ p → ◻ q ) ∨ ( p → ( ( ¬ p ∨ ◻ ⊥ ) → ( ¬ ( q ∧ ◻ ⊥ ) ∨ ( p ∧ ( ◻ q → q ) ) ) ) )", "s4") == true
            @test isValidFrame("( ◇ p → ◻ q ) ∨ ( p → ( ( ¬ p ∨ ◻ ⊥ ) → ( ¬ ( q ∧ ◻ ⊥ ) ∨ ( p ∧ ( ◻ q → q ) ) ) ) )", "s4") == true
            # line 72 in tripleTC.txt
            @test isValidModel("p → ( ◻ ( ( ¬ q ∧ ¬ ( p ∧ q ) ) ↔ ( ◻ ( p ∧ q ) → p ) ) ∨ ( ( ◇ ¬ q → ( ¬ ( ( p ↔ q ) ∨ ◻ p ) ∧ ( q → ◻ ◇ ◇ p ) ) ) ∨ ( ( ◻ ◻ ⊥ → ( ◻ ⊥ → ( ( ¬ p → ( ◇ ¬ q ∧ ◻ ⊥ ) ) ∨ ( ( ( q → ◇ p ) ∧ ◇ q ) ∨ p ) ) ) ) ∨ ( ( ( ◻ ⊥ ↔ p ) ∧ ◇ q ) ∨ ( p ∧ ( ◻ ⊥ ↔ ( ( q → p ) ∨ ( q ∨ p ) ) ) ) ) ) ) )") == true
            @test isValidFrame("p → ( ◻ ( ( ¬ q ∧ ¬ ( p ∧ q ) ) ↔ ( ◻ ( p ∧ q ) → p ) ) ∨ ( ( ◇ ¬ q → ( ¬ ( ( p ↔ q ) ∨ ◻ p ) ∧ ( q → ◻ ◇ ◇ p ) ) ) ∨ ( ( ◻ ◻ ⊥ → ( ◻ ⊥ → ( ( ¬ p → ( ◇ ¬ q ∧ ◻ ⊥ ) ) ∨ ( ( ( q → ◇ p ) ∧ ◇ q ) ∨ p ) ) ) ) ∨ ( ( ( ◻ ⊥ ↔ p ) ∧ ◇ q ) ∨ ( p ∧ ( ◻ ⊥ ↔ ( ( q → p ) ∨ ( q ∨ p ) ) ) ) ) ) ) )") == true
            @test isValidModel("p → ( ◻ ( ( ¬ q ∧ ¬ ( p ∧ q ) ) ↔ ( ◻ ( p ∧ q ) → p ) ) ∨ ( ( ◇ ¬ q → ( ¬ ( ( p ↔ q ) ∨ ◻ p ) ∧ ( q → ◻ ◇ ◇ p ) ) ) ∨ ( ( ◻ ◻ ⊥ → ( ◻ ⊥ → ( ( ¬ p → ( ◇ ¬ q ∧ ◻ ⊥ ) ) ∨ ( ( ( q → ◇ p ) ∧ ◇ q ) ∨ p ) ) ) ) ∨ ( ( ( ◻ ⊥ ↔ p ) ∧ ◇ q ) ∨ ( p ∧ ( ◻ ⊥ ↔ ( ( q → p ) ∨ ( q ∨ p ) ) ) ) ) ) ) )", "k4") == true
            @test isValidFrame("p → ( ◻ ( ( ¬ q ∧ ¬ ( p ∧ q ) ) ↔ ( ◻ ( p ∧ q ) → p ) ) ∨ ( ( ◇ ¬ q → ( ¬ ( ( p ↔ q ) ∨ ◻ p ) ∧ ( q → ◻ ◇ ◇ p ) ) ) ∨ ( ( ◻ ◻ ⊥ → ( ◻ ⊥ → ( ( ¬ p → ( ◇ ¬ q ∧ ◻ ⊥ ) ) ∨ ( ( ( q → ◇ p ) ∧ ◇ q ) ∨ p ) ) ) ) ∨ ( ( ( ◻ ⊥ ↔ p ) ∧ ◇ q ) ∨ ( p ∧ ( ◻ ⊥ ↔ ( ( q → p ) ∨ ( q ∨ p ) ) ) ) ) ) ) )", "k4") == true
            @test isValidModel("p → ( ◻ ( ( ¬ q ∧ ¬ ( p ∧ q ) ) ↔ ( ◻ ( p ∧ q ) → p ) ) ∨ ( ( ◇ ¬ q → ( ¬ ( ( p ↔ q ) ∨ ◻ p ) ∧ ( q → ◻ ◇ ◇ p ) ) ) ∨ ( ( ◻ ◻ ⊥ → ( ◻ ⊥ → ( ( ¬ p → ( ◇ ¬ q ∧ ◻ ⊥ ) ) ∨ ( ( ( q → ◇ p ) ∧ ◇ q ) ∨ p ) ) ) ) ∨ ( ( ( ◻ ⊥ ↔ p ) ∧ ◇ q ) ∨ ( p ∧ ( ◻ ⊥ ↔ ( ( q → p ) ∨ ( q ∨ p ) ) ) ) ) ) ) )", "s4") == true
            @test isValidFrame("p → ( ◻ ( ( ¬ q ∧ ¬ ( p ∧ q ) ) ↔ ( ◻ ( p ∧ q ) → p ) ) ∨ ( ( ◇ ¬ q → ( ¬ ( ( p ↔ q ) ∨ ◻ p ) ∧ ( q → ◻ ◇ ◇ p ) ) ) ∨ ( ( ◻ ◻ ⊥ → ( ◻ ⊥ → ( ( ¬ p → ( ◇ ¬ q ∧ ◻ ⊥ ) ) ∨ ( ( ( q → ◇ p ) ∧ ◇ q ) ∨ p ) ) ) ) ∨ ( ( ( ◻ ⊥ ↔ p ) ∧ ◇ q ) ∨ ( p ∧ ( ◻ ⊥ ↔ ( ( q → p ) ∨ ( q ∨ p ) ) ) ) ) ) ) )", "s4") == true
            # line 94 in tripleTC.txt
            @test isValidModel("◇ p → ( ¬ ( p → ( ◇ ⊤ → ( ◇ ( ◇ p ↔ ( ◻ ⊥ ↔ ( ¬ p → ¬ q ) ) ) ↔ p ) ) ) → p )") == true
            @test isValidFrame("◇ p → ( ¬ ( p → ( ◇ ⊤ → ( ◇ ( ◇ p ↔ ( ◻ ⊥ ↔ ( ¬ p → ¬ q ) ) ) ↔ p ) ) ) → p )") == true
            @test isValidModel("◇ p → ( ¬ ( p → ( ◇ ⊤ → ( ◇ ( ◇ p ↔ ( ◻ ⊥ ↔ ( ¬ p → ¬ q ) ) ) ↔ p ) ) ) → p )", "k4") == true
            @test isValidFrame("◇ p → ( ¬ ( p → ( ◇ ⊤ → ( ◇ ( ◇ p ↔ ( ◻ ⊥ ↔ ( ¬ p → ¬ q ) ) ) ↔ p ) ) ) → p )", "k4") == true
            @test isValidModel("◇ p → ( ¬ ( p → ( ◇ ⊤ → ( ◇ ( ◇ p ↔ ( ◻ ⊥ ↔ ( ¬ p → ¬ q ) ) ) ↔ p ) ) ) → p )", "s4") == true
            @test isValidFrame("◇ p → ( ¬ ( p → ( ◇ ⊤ → ( ◇ ( ◇ p ↔ ( ◻ ⊥ ↔ ( ¬ p → ¬ q ) ) ) ↔ p ) ) ) → p )", "s4") == true
        end

        @testset "Randomly generated modal contradictions" begin
            # line 55 in tripleTC.txt
            @test isValidModel("q ∧ ◇ ( ◻ q ∧ ◇ ◇ ¬ ( p ∨ q ) )") == false
            @test isValidFrame("q ∧ ◇ ( ◻ q ∧ ◇ ◇ ¬ ( p ∨ q ) )") == false
            @test isValidModel("q ∧ ◇ ( ◻ q ∧ ◇ ◇ ¬ ( p ∨ q ) )", "k4") == false
            @test isValidFrame("q ∧ ◇ ( ◻ q ∧ ◇ ◇ ¬ ( p ∨ q ) )", "k4") == false
            @test isValidModel("q ∧ ◇ ( ◻ q ∧ ◇ ◇ ¬ ( p ∨ q ) )", "s4") == false
            @test isValidFrame("q ∧ ◇ ( ◻ q ∧ ◇ ◇ ¬ ( p ∨ q ) )", "s4") == false
            # line 91 in tripleTC.txt
            @test isValidModel("q ∧ ( ¬ ( q ∨ ◇ ¬ p ) ∧ ◻ ◻ ¬ ( ( ( ◇ ( q → ◻ q ) ∧ ( q → ◇ ◇ q ) ) → p ) ∧ ◻ p ) )") == false
            @test isValidFrame("q ∧ ( ¬ ( q ∨ ◇ ¬ p ) ∧ ◻ ◻ ¬ ( ( ( ◇ ( q → ◻ q ) ∧ ( q → ◇ ◇ q ) ) → p ) ∧ ◻ p ) )") == false
            @test isValidModel("q ∧ ( ¬ ( q ∨ ◇ ¬ p ) ∧ ◻ ◻ ¬ ( ( ( ◇ ( q → ◻ q ) ∧ ( q → ◇ ◇ q ) ) → p ) ∧ ◻ p ) )", "k4") == false
            @test isValidFrame("q ∧ ( ¬ ( q ∨ ◇ ¬ p ) ∧ ◻ ◻ ¬ ( ( ( ◇ ( q → ◻ q ) ∧ ( q → ◇ ◇ q ) ) → p ) ∧ ◻ p ) )", "k4") == false
            @test isValidModel("q ∧ ( ¬ ( q ∨ ◇ ¬ p ) ∧ ◻ ◻ ¬ ( ( ( ◇ ( q → ◻ q ) ∧ ( q → ◇ ◇ q ) ) → p ) ∧ ◻ p ) )", "s4") == false
            @test isValidFrame("q ∧ ( ¬ ( q ∨ ◇ ¬ p ) ∧ ◻ ◻ ¬ ( ( ( ◇ ( q → ◻ q ) ∧ ( q → ◇ ◇ q ) ) → p ) ∧ ◻ p ) )", "s4") == false
            # line 64 in tripleTC.txt
            @test isValidModel("¬ ( ( q → ( q ∨ ( ◇ ◻ ¬ ( q ∨ p ) → p ) ) ) ∨ ◻ q )") == false
            @test isValidFrame("¬ ( ( q → ( q ∨ ( ◇ ◻ ¬ ( q ∨ p ) → p ) ) ) ∨ ◻ q )") == false
            @test isValidModel("¬ ( ( q → ( q ∨ ( ◇ ◻ ¬ ( q ∨ p ) → p ) ) ) ∨ ◻ q )", "k4") == false
            @test isValidFrame("¬ ( ( q → ( q ∨ ( ◇ ◻ ¬ ( q ∨ p ) → p ) ) ) ∨ ◻ q )", "k4") == false
            @test isValidModel("¬ ( ( q → ( q ∨ ( ◇ ◻ ¬ ( q ∨ p ) → p ) ) ) ∨ ◻ q )", "s4") == false
            @test isValidFrame("¬ ( ( q → ( q ∨ ( ◇ ◻ ¬ ( q ∨ p ) → p ) ) ) ∨ ◻ q )", "s4") == false
            # line 49 in tripleTC.txt
            @test isValidModel("◇ ¬ ( ( q ∧ ( ◻ q ∧ ◻ ( q → ¬ q ) ) ) → ( ◇ p → ◇ ¬ p ) )") == false
            @test isValidFrame("◇ ¬ ( ( q ∧ ( ◻ q ∧ ◻ ( q → ¬ q ) ) ) → ( ◇ p → ◇ ¬ p ) )") == false
            @test isValidModel("◇ ¬ ( ( q ∧ ( ◻ q ∧ ◻ ( q → ¬ q ) ) ) → ( ◇ p → ◇ ¬ p ) )", "k4") == false
            @test isValidFrame("◇ ¬ ( ( q ∧ ( ◻ q ∧ ◻ ( q → ¬ q ) ) ) → ( ◇ p → ◇ ¬ p ) )", "k4") == false
            @test isValidModel("◇ ¬ ( ( q ∧ ( ◻ q ∧ ◻ ( q → ¬ q ) ) ) → ( ◇ p → ◇ ¬ p ) )", "s4") == false
            @test isValidFrame("◇ ¬ ( ( q ∧ ( ◻ q ∧ ◻ ( q → ¬ q ) ) ) → ( ◇ p → ◇ ¬ p ) )", "s4") == false
            # line 1 in tripleTC.txt
            @test isValidModel("◇ ⊤ ↔ ◻ ⊥") == false
            @test isValidFrame("◇ ⊤ ↔ ◻ ⊥") == false
            @test isValidModel("◇ ⊤ ↔ ◻ ⊥", "k4") == false
            @test isValidFrame("◇ ⊤ ↔ ◻ ⊥", "k4") == false
            @test isValidModel("◇ ⊤ ↔ ◻ ⊥", "s4") == false
            @test isValidFrame("◇ ⊤ ↔ ◻ ⊥", "s4") == false
            
        end
    
    end
end