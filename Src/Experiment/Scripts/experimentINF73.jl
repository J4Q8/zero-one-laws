include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("gl", 40, 5, true, "validated-Peregrine-inf-prop")
