include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("k4", 72, 2, true, "validated-Peregrine-inf-prop")
