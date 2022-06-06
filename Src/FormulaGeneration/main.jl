include("formulaGenerator.jl")
using .FormulaGenerator

@time @allocated runGenerator(100,7,13)