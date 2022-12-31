include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("gl", 72, 4, true, "validated-Peregrine-inf-prop")
