include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("s4", 80, 7, false, "validated-Peregrine")
