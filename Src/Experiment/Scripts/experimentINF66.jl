include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("k4", 80, 4, true, "validated-Peregrine-inf-prop")
