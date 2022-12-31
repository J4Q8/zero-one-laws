include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("gl", 80, 3, true, "validated-Peregrine-inf-prop")
