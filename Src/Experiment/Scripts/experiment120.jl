include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("k4", 80, 7, false, "validated-Peregrine")
