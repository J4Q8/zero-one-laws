include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("k4", 64, 6, true, "validated-Peregrine-inf-prop")
