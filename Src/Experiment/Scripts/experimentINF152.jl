include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("k4", 48, 9, true, "validated-Peregrine-inf-prop")
