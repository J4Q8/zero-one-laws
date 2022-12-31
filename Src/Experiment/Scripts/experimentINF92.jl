include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("gl", 48, 6, true, "validated-Peregrine-inf-prop")
