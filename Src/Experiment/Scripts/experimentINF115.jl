include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("k4", 40, 7, true, "validated-Peregrine-inf-prop")
