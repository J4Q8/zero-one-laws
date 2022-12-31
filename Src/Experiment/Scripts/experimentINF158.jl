include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("s4", 48, 9, true, "validated-Peregrine-inf-prop")
