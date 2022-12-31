include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("k4", 72, 8, true, "validated-Peregrine-inf-prop")
