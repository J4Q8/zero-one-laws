include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("k4", 80, 10, true, "validated-Peregrine-inf-prop")
