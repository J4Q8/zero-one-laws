include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("gl", 56, 6, false, "validated-Peregrine")
