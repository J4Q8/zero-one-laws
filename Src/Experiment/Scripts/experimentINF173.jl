include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("k4", 72, 10, true, "validated-Peregrine-inf-prop")
