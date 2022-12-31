include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("gl", 80, 7, true, "validated-Peregrine-inf-prop")
