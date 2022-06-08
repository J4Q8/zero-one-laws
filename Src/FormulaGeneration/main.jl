include("formulaGenerator.jl")
using .FormulaGenerator

@time @allocated runGenerator(2,100,6,13)