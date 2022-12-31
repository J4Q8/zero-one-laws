include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("k4", 48, 10, true, "validated-Peregrine-inf-prop")
