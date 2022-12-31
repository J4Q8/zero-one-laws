include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("k4", 56, 5, true, "validated-Peregrine-inf-prop")
