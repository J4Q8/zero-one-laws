include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("gl", 40, 6, true, "validated-Peregrine-inf-prop")
