include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("k4", 56, 7, true, "validated-Peregrine-inf-prop")
