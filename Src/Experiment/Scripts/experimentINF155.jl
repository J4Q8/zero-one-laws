include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("k4", 72, 9, true, "validated-Peregrine-inf-prop")
