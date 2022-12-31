include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("k4", 64, 1, true, "validated-Peregrine-inf-prop")
