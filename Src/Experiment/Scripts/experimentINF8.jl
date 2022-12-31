include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("k4", 48, 1, true, "validated-Peregrine-inf-prop")
