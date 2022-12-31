include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("gl", 56, 5, true, "validated-Peregrine-inf-prop")
