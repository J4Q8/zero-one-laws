include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("k4", 80, 2, true, "validated-Peregrine-inf-prop")
