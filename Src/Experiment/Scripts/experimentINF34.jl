include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("s4", 64, 2, true, "validated-Peregrine-inf-prop")
