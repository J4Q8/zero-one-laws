include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("gl", 64, 2, true, "validated-Peregrine-inf-prop")
