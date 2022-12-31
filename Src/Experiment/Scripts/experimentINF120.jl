include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("k4", 80, 7, true, "validated-Peregrine-inf-prop")
