include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("gl", 48, 4, true, "validated-Peregrine-inf-prop")
