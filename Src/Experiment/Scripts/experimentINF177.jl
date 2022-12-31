include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("s4", 56, 10, true, "validated-Peregrine-inf-prop")
