include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("s4", 56, 1, true, "validated-Peregrine-inf-prop")
