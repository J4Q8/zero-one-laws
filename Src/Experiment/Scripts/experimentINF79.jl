include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("k4", 40, 5, true, "validated-Peregrine-inf-prop")
