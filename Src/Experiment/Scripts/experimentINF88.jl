include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("s4", 64, 5, true, "validated-Peregrine-inf-prop")
