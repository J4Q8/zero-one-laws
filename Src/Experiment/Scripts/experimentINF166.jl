include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("gl", 64, 10, true, "validated-Peregrine-inf-prop")
