include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("k4", 72, 3, true, "validated-Peregrine-inf-prop")
