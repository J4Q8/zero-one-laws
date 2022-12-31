include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("gl", 64, 4, true, "validated-Peregrine-inf-prop")
