include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("k4", 80, 4, false, "validated-Peregrine")
