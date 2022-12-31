include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("gl", 72, 8, true, "validated-Peregrine-inf-prop")
