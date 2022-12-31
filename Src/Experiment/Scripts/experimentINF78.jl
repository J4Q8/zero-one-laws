include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("gl", 80, 5, true, "validated-Peregrine-inf-prop")
