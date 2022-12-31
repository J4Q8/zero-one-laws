include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("s4", 56, 2, true, "validated-Peregrine-inf-prop")
