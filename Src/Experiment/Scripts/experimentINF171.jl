include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("k4", 56, 10, true, "validated-Peregrine-inf-prop")
