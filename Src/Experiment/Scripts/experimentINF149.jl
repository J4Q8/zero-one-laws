include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("gl", 72, 9, true, "validated-Peregrine-inf-prop")
