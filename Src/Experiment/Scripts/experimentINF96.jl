include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("gl", 80, 6, true, "validated-Peregrine-inf-prop")
