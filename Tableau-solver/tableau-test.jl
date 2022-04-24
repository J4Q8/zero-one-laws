include("interface.jl")

using .Interface
using Test

@testset verbose = true "Tableau tests" begin

    @testset "propositional formulas" begin
        @test validate("( p → q ) ∧ p", "q") == true
        @test validate("( p → q ) ∧ ( q → r )", "( p → r )") == true
        @test validate("", "( ( p → q ) ∧ ( p → r ) ) → ( p → ( q ∧ r ) )") == true
        @test validate("( p → q ) ∨ ( r → q )", "( p ∨ r ) → q") == false
        @test validate("", "( p ↔ q ) ↔ ( ¬ p ↔ ¬ q )") == true
    end

    @testset "modal formulas" begin
        @test validate("◻ ( p → q ) ∧ ◻ ( q → r )", "◻ ( p → r )") == true
        @test validate("", "◇ ( p ∧ q ) → ( ◇ p ∧ ◇ q )") == true
        @test validate("◇ ◻ ◇p", "◇p") == false
        @test validate(" ◻ ( p ∧ q )", "◻ p ∧ ◻ q") == true
        @test validate("◇p", "◇ ◻ ◇p") == false
        @test validate("", "◻ p → p") == false
    end 

    @testset "modal formulas with constraints" begin
        @test validate("", "◻ p → p", "r") == true
        @test validate("", "◻ p → ◻ ◻ p", "r") == false
        @test validate("", "◻ p → ◻ ◻ p", "rt") == true
        @test validate("", "p → ◻ ◇ p", "s") == true
        @test validate("", "◻ p → ◻ ◻ p", "t") == true
        @test validate("", "◇ p → ◻ ◇ p", "st") == true
        @test validate("", "◻ p → ◻ ◻ p", "rs") == false
        @test validate("", "◻ ◻ p → ◻ p", "t") == false
        @test validate("", "¬ ( ◇ p ∧ ◻ ◇ p )", "") == false
        @test validate("", "( ◻ ( p → q ) ∧ ◇ ( p ∧ r ) ) → ◇ ( q ∧ r )", "r") == true
        @test validate("", "( ◻ p ∧ ◻ q ) → ( p ↔ q )", "r") == true
        @test validate("", "◇ ( p → q ) ↔ ( ◻ p → ◇ q )", "r") == true
        @test validate("", "( ◇ ¬ p ∨ ◇ ¬ q ) ∨ ◇ ( p ∨ q )", "r") == true
        @test validate("", "◇ ( p → ( q ∧ r ) ) → ( ( ◻ p → ◇ q ) ∧ ( ◻ p → ◇ r ) )", "r") == true
        @test validate("", "( ◻ p ∨ ◻ q ) ↔ ◻ ( ◻ p ∨ ◻ q )", "rt") == true
        @test validate("", "◻ ( ◻ ( p ↔ q ) → r ) → ( ◻ ( p ↔ q ) → ◻ r )", "rt") == true
        @test validate("", "◻ p → ◻ ◻ p", "gl") == true
        @test validate("", "◻ ( ◻ p → p ) → ◻p", "gl") == true
        @test validate("", "¬ p ∨p", "gl") == true
        @test validate("", "p →p", "gl") == true
        @test validate("", "¬ ⊥", "gl") == true
        @test validate("", "( p ∧ q ) ∨ ( ¬ p ∨ ¬ q )", "gl") == true
        @test validate("", "◇ p → ¬ ⊥", "gl") == true
        @test validate("", "◻ ( ◇ ⊥ → ( p ∧ p ) )", "gl") == true
        @test validate("", "( p ∨ p ) ↔ ( ⊥ ∨ p )", "gl") == true
        @test validate("", "p ∧ ¬p", "gl") == false
        @test validate("", "p ∨p", "gl") == false
        @test validate("", "◻ ◻p", "gl") == false
        @test validate("", "( p ∨ ¬ p ) ∧ ( ( ¬ ⊥ ∧ ¬ ⊥ ) ∧ p )", "gl") == false
        @test validate("", "( ⊥ ∧ ⊥ ) ∨ ( ( p ∨ p ) ↔ ( q ∨ q ) )", "gl") == false
        @test validate("", "◇ p → ¬ q", "gl") == false
        @test validate("", "◻ ◻ ◇ ( p ↔ p ) ∧ ◻ ◻ ◇ ◻ ( p ∧ ¬ p )", "gl") == false
        @test validate("", "◻ ( ◻ p → p ) → ◻p", "gl") == true
    end 

end
