include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("s4", 48, 6, true, "validated-Peregrine-inf-prop")
