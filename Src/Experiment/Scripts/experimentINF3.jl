include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("gl", 56, 1, true, "validated-Peregrine-inf-prop")
