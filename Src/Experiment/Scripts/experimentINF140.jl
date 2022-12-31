include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("s4", 48, 8, true, "validated-Peregrine-inf-prop")
