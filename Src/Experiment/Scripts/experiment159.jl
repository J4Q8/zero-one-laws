include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("s4", 56, 9, false, "validated-Peregrine")
