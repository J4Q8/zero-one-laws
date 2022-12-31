include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("gl", 48, 10, true, "validated-Peregrine-inf-prop")
