include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("s4", 56, 9, true, "validated-Peregrine-inf-prop")
