include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("gl", 40, 1, true, "validated-Peregrine-inf-prop")
