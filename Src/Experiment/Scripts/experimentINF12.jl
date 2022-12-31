include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("k4", 80, 1, true, "validated-Peregrine-inf-prop")
