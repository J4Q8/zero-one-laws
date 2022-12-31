include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("k4", 64, 4, true, "validated-Peregrine-inf-prop")
