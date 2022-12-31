include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("k4", 40, 1, true, "validated-Peregrine-inf-prop")
