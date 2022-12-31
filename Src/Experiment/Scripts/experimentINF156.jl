include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("k4", 80, 9, true, "validated-Peregrine-inf-prop")
