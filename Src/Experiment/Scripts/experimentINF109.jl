include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("gl", 40, 7, true, "validated-Peregrine-inf-prop")
