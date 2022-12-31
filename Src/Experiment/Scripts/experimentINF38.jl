include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("gl", 48, 3, true, "validated-Peregrine-inf-prop")
