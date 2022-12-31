include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("k4", 48, 8, true, "validated-Peregrine-inf-prop")
