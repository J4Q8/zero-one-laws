include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("s4", 48, 10, true, "validated-Peregrine-inf-prop")
