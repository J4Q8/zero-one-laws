include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("gl", 56, 7, false, "validated-Peregrine")
