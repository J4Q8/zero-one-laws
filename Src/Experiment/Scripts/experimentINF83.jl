include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("k4", 72, 5, true, "validated-Peregrine-inf-prop")
