include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("k4", 56, 4, true, "validated-Peregrine-inf-prop")
