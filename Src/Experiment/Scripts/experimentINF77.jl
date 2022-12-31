include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("gl", 72, 5, true, "validated-Peregrine-inf-prop")
