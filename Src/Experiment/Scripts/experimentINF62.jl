include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("k4", 48, 4, true, "validated-Peregrine-inf-prop")
