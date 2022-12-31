include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("gl", 48, 2, true, "validated-Peregrine-inf-prop")
