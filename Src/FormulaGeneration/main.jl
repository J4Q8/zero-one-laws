include("formulaGenerator.jl")
using .FormulaGenerator

@time @allocated runGenerator(1,100,6,13)