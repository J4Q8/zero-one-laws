include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("gl", 80, 8, true, "validated-Peregrine-inf-prop")
