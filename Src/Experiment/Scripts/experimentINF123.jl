include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("s4", 56, 7, true, "validated-Peregrine-inf-prop")
