include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("k4", 72, 7, true, "validated-Peregrine-inf-prop")
