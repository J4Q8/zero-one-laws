include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("s4", 72, 5, true, "validated-Peregrine-inf-prop")
