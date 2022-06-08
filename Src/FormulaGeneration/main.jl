include("formulaGenerator.jl")
using .FormulaGenerator

@time @allocated runGenerator(3,100,6,13)