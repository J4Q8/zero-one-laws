include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("gl", 40, 8, true, "validated-Peregrine-inf-prop")
