include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("k4", 48, 6, true, "validated-Peregrine-inf-prop")
