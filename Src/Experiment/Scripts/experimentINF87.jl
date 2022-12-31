include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("s4", 56, 5, true, "validated-Peregrine-inf-prop")
