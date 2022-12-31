include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("s4", 72, 8, true, "validated-Peregrine-inf-prop")
