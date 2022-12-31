include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("k4", 56, 8, true, "validated-Peregrine-inf-prop")
