include("experimentalSetup.jl")

using .ExperimentalSetup

runExperiment("k4", 64, 10, false)
