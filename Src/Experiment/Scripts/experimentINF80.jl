include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("k4", 48, 5, true, "validated-Peregrine-inf-prop")
