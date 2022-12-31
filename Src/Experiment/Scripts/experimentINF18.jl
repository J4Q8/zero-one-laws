include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("s4", 80, 1, true, "validated-Peregrine-inf-prop")
