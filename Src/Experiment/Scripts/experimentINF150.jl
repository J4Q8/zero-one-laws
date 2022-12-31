include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("gl", 80, 9, true, "validated-Peregrine-inf-prop")
