include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("s4", 56, 6, true, "validated-Peregrine-inf-prop")
