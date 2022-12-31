include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("k4", 56, 9, true, "validated-Peregrine-inf-prop")
