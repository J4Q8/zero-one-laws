include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("gl", 56, 3, true, "validated-Peregrine-inf-prop")
