include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("gl", 80, 2, true, "validated-Peregrine-inf-prop")
