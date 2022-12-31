include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("k4", 80, 3, true, "validated-Peregrine-inf-prop")
