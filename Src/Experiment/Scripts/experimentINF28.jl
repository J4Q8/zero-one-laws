include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("k4", 64, 2, true, "validated-Peregrine-inf-prop")
