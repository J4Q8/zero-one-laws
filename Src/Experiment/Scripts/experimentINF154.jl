include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("k4", 64, 9, true, "validated-Peregrine-inf-prop")
