include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("gl", 64, 1, true, "validated-Peregrine-inf-prop")
