include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("s4", 72, 9, true, "validated-Peregrine-inf-prop")
