include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("k4", 40, 4, true, "validated-Peregrine-inf-prop")
