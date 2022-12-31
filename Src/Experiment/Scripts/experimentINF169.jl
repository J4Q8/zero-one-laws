include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("k4", 40, 10, true, "validated-Peregrine-inf-prop")
