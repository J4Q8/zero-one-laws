include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("gl", 48, 9, true, "validated-Peregrine-inf-prop")
