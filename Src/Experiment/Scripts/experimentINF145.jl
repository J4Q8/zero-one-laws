include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("gl", 40, 9, true, "validated-Peregrine-inf-prop")
