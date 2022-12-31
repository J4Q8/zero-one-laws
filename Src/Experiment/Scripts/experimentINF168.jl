include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("gl", 80, 10, true, "validated-Peregrine-inf-prop")
