include("experimentalSetup.jl")

using .ExperimentalSetup

runExperiment("gl", 64, 10, false)
