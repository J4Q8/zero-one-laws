include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("k4", 72, 4, true, "validated-Peregrine-inf-prop")
