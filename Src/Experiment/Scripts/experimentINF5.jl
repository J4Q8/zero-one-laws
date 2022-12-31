include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("gl", 72, 1, true, "validated-Peregrine-inf-prop")
