include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("gl", 64, 5, true, "validated-Peregrine-inf-prop")
