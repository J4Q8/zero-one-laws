include("experimentalSetup.jl")

using .ExperimentalSetup

runExperiment("k4", 64, 8, false)
