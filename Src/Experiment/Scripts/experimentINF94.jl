include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("gl", 64, 6, true, "validated-Peregrine-inf-prop")
