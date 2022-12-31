include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("s4", 72, 2, true, "validated-Peregrine-inf-prop")
