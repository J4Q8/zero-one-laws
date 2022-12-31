include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("gl", 72, 10, true, "validated-Peregrine-inf-prop")
