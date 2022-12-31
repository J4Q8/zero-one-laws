include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("s4", 72, 6, true, "validated-Peregrine-inf-prop")
