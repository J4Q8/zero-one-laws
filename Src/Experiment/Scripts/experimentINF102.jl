include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("k4", 80, 6, true, "validated-Peregrine-inf-prop")
