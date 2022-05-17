include("formulaGenerator.jl")
using .FormulaGenerator

@time @allocated runGenerator(10,6,13)