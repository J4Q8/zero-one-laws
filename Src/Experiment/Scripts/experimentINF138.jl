include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("k4", 80, 8, true, "validated-Peregrine-inf-prop")
