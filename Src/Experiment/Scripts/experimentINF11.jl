include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("k4", 72, 1, true, "validated-Peregrine-inf-prop")
