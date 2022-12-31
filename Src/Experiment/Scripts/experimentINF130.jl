include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("gl", 64, 8, true, "validated-Peregrine-inf-prop")
