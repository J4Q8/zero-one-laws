include("experimentalSetup.jl")

using .ExperimentalSetup

runExperiment("k4", 64, 4, false)
