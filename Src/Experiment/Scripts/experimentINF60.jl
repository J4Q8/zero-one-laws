include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("gl", 80, 4, true, "validated-Peregrine-inf-prop")
