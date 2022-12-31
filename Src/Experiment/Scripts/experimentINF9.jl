include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("k4", 56, 1, true, "validated-Peregrine-inf-prop")
