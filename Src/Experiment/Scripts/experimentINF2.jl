include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("gl", 48, 1, true, "validated-Peregrine-inf-prop")
