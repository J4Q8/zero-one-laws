include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("s4", 56, 8, true, "validated-Peregrine-inf-prop")
