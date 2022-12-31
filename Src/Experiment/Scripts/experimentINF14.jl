include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("s4", 48, 1, true, "validated-Peregrine-inf-prop")
