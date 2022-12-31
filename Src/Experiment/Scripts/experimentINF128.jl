include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("gl", 48, 8, true, "validated-Peregrine-inf-prop")
