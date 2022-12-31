include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("gl", 48, 5, true, "validated-Peregrine-inf-prop")
