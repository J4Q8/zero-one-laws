include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("gl", 48, 7, false, "validated-Peregrine")
