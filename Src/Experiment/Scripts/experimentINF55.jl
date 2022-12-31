include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("gl", 40, 4, true, "validated-Peregrine-inf-prop")
