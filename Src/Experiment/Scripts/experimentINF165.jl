include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("gl", 56, 10, true, "validated-Peregrine-inf-prop")
