include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("k4", 56, 2, true, "validated-Peregrine-inf-prop")
