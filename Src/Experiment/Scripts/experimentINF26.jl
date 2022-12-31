include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("k4", 48, 2, true, "validated-Peregrine-inf-prop")
