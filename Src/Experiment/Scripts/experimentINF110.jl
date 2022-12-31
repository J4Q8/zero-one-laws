include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("gl", 48, 7, true, "validated-Peregrine-inf-prop")
