include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("k4", 72, 6, true, "validated-Peregrine-inf-prop")
