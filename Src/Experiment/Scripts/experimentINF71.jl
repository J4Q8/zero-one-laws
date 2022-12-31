include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("s4", 72, 4, true, "validated-Peregrine-inf-prop")
