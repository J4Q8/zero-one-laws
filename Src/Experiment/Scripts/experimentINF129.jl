include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("gl", 56, 8, true, "validated-Peregrine-inf-prop")
