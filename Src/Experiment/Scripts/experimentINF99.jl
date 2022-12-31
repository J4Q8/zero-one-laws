include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("k4", 56, 6, true, "validated-Peregrine-inf-prop")
