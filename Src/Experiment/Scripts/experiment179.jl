include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("s4", 72, 10, false, "validated-Peregrine")
