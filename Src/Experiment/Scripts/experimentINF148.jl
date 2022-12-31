include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("gl", 64, 9, true, "validated-Peregrine-inf-prop")
