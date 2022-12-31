include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("k4", 40, 9, true, "validated-Peregrine-inf-prop")
