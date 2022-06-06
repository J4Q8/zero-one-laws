
include(joinpath("..", joinpath("FormulaUtils","trees.jl")))
include(joinpath("..", joinpath("FormulaUtils","cleaner.jl")))
include(joinpath("..", joinpath("FormulaUtils","parser.jl")))
include(joinpath("..", joinpath("FormulaUtils","simplifier.jl")))
include("structures.jl")

using Test
using .Trees
using .Parser
using .Simplifier
using .Structures


function isvalid(formula::String)
    
end


@testset verbose = true "ModelCheckerTest" begin

    @testset "Propositional tautologies" begin
        @test testE("p ∧ ( q ∧ r )", "(p ∧ q) ∧ r")
        @test testE("p ∧ ( q ∧ r )", "(p ∧ r) ∧ q")
        @test testE("(p^r)^(q^r)", "((p^p)^q)^r")
        @test testE("p^r", "r^p")
        @test testE("T", "~F")
        @test testE("~T", "~~F")
        @test testE("T^F", "F^T")
        @test testE("p^(q^(r^F))", "(~T^q)^(p^r)")
    end

    @testset "multiple disjuncts" begin
        @test testE("p V ( q V r )", "(p V q) V r")
        @test testE("p V ( q V r )", "(p V r) V q")
        @test testE("(pVr)V(qVr)", "((pVp)Vq)Vr")
        @test testE("pVr", "rVp")
        @test testE("TVF", "FVT")
        @test testE("~T", "F")
        @test testE("~~T", "~F")
        @test testE("pV(qV(rVF))", "(~TVq)V(pVr)")
    end 

    @testset "multiple bimplications" begin
        @test testE("p = ( q = r )", "(p = q) = r")
        @test testE("p = ( q = r )", "(p = r) = q")
        @test testE("(p=r)=(q=r)", "((p=p)=q)=r")
        @test testE("p=r", "r=p")
        @test testE("T=F", "F=T")
        @test testE("~T", "F")
        @test testE("~~T", "~F")
        @test testE("p=(q=(r=F))", "(~T=q)=(p=r)")
    end

end

@testset verbose = true "Simplifier tests" begin

    @testset "multiple conjuncts" begin
        @test testS("(T^T)^F", "F")
        @test testS("(T^T)^(T^T)", "T")
        @test testS("(T^T)^(T^F)", "F")
        @test testS("(T^p)^(T^T)", "p")
        @test testS("(T^p)^(F^T)", "F")
        @test testS("(T^p)^(T^~p)", "F")
        @test testS("(T^p)^(r^p)", "p^r")
        @test testS("(T^p)^(r^(p^(F^T)))", "F")
        @test testS("(T^p)^(r^(p^(q^T)))", "p^(r^q)")
        @test testS("(~q^p)^(r^(p^(q^T)))", "F")
    end

    @testset "multiple disjuncts" begin
        @test testS("(TVT)VF", "T")
        @test testS("(TVT)V(TVT)", "T")
        @test testS("(FVT)V(TVF)", "T")
        @test testS("(TVp)V(TVT)", "T")
        @test testS("(FVp)V(FVF)", "p")
        @test testS("(TVp)V(FVT)", "T")
        @test testS("(TVp)V(TV~p)", "T")
        @test testS("(FVF)V(FV~T)", "F")
        @test testS("(FVp)V(rVp)", "pVr")
        @test testS("(TVp)V(rV(pV(FVT)))", "T")
        @test testS("(FVp)V(rV(pV(qVF)))", "pV(rVq)")
        @test testS("(~qVp)V(rV(pV(qVT)))", "T")
    end 

    @testset "multiple bimplications" begin
        @test testS("(T↔T)↔F", "F")
        @test testS("(T↔T)↔(T↔T)", "T")
        @test testS("(F↔T)↔(T↔F)", "T")
        @test testS("(T↔p)↔(T↔T)", "p")
        @test testS("(F↔p)↔(F↔F)", "~p")
        @test testS("(T↔p)↔(F↔T)", "~p")
        @test testS("(T↔p)↔(T↔~p)", "F")
        @test testS("(F↔F)↔(F↔~T)", "T")
        @test testS("(F↔p)↔(r↔p)", "~r")
        @test testS("(T↔p)↔(r↔(p↔(F↔T)))", "~r")
        @test testS("(F↔p)↔(r↔(p↔(q↔F)))", "q↔r")
        @test testS("(~q↔p)↔(r↔(p↔(q↔T)))", "~r")
    end 

    @testset "complex simplifications" begin
        @test testS("(~q^p)^(r^(p^(q-T)))", "((p^~q)^r)")
        @test testS("◻ ( ◻ ⊤ ∧ ◻ ( ◻ ( q → p ) ↔ ( ◻ ⊥ ∧ ( ⊥ ∧ ⊤ ) ) ) )", "◻ ( ◻ ( ◇~ ( q → p )) )")
        @test testS("(p->q)^~(p->q)" ,"F")
        @test testS("((p->q)^~(p->q))V((p=p)->q)" ,"q")
        @test testS("(◻ ⊤ ∧ (( ◇ F) ^p))->(p^~p)" ,"T")
        @test testS("(~◻ F ∧ ~◇(( ◇ F) ^p))->(p^~p)" ,"◻ F ")
        @test testS("((((~~~~~pVp)=T)->F)->F)^(r^p)", "r^p")
    end 
    

end