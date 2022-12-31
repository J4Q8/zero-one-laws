include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("gl", 64, 7, true, "validated-Peregrine-inf-prop")
