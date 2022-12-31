include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("gl", 56, 2, true, "validated-Peregrine-inf-prop")
