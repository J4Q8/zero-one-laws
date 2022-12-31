include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("gl", 72, 2, true, "validated-Peregrine-inf-prop")
