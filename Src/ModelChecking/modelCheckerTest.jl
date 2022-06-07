
include(joinpath("..", joinpath("FormulaUtils","trees.jl")))
include(joinpath("..", joinpath("FormulaUtils","cleaner.jl")))
include(joinpath("..", joinpath("FormulaUtils","parser.jl")))
include(joinpath("..", joinpath("FormulaUtils","simplifier.jl")))
include("structures.jl")
include("specializedModelChecker.jl")

using Test
using .Trees
using .Parser
using .Simplifier
using .Structures
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
        model = generateModel(80, language)
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
    
    end
end