include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("s4", 48, 4, true, "validated-Peregrine-inf-prop")
