include("formulaGenerator.jl")
using .FormulaGenerator

@time @allocated runGenerator(10,100,6,13)