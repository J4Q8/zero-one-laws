include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("s4", 56, 4, true, "validated-Peregrine-inf-prop")
