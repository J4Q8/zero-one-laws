include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("gl", 40, 5, false, "validated-Peregrine")
