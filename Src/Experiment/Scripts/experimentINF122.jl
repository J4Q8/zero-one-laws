include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("s4", 48, 7, true, "validated-Peregrine-inf-prop")
