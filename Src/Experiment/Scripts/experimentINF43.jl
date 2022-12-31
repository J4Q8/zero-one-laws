include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("k4", 40, 3, true, "validated-Peregrine-inf-prop")
