include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("gl", 72, 7, true, "validated-Peregrine-inf-prop")
