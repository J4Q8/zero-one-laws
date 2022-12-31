include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("k4", 40, 6, true, "validated-Peregrine-inf-prop")
