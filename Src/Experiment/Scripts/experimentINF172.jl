include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("k4", 64, 10, true, "validated-Peregrine-inf-prop")
