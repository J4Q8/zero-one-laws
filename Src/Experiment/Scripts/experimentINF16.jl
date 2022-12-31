include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("s4", 64, 1, true, "validated-Peregrine-inf-prop")
