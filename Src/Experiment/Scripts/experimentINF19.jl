include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("gl", 40, 2, true, "validated-Peregrine-inf-prop")
