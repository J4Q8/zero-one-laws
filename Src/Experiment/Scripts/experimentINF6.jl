include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("gl", 80, 1, true, "validated-Peregrine-inf-prop")
