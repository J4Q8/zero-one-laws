include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("s4", 72, 1, true, "validated-Peregrine-inf-prop")
