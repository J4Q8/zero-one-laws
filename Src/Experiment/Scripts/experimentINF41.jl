include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("gl", 72, 3, true, "validated-Peregrine-inf-prop")
