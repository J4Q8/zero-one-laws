include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("gl", 56, 4, true, "validated-Peregrine-inf-prop")
