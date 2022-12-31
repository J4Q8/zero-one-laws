include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("gl", 72, 6, true, "validated-Peregrine-inf-prop")
