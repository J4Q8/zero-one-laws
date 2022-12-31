include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("k4", 40, 8, true, "validated-Peregrine-inf-prop")
