include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("s4", 64, 3, true, "validated-Peregrine-inf-prop")
