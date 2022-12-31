include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("gl", 56, 9, true, "validated-Peregrine-inf-prop")
