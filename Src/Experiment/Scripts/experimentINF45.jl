include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("k4", 56, 3, true, "validated-Peregrine-inf-prop")
