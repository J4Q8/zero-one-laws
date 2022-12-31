include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("gl", 40, 10, true, "validated-Peregrine-inf-prop")
