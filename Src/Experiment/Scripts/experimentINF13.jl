include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("s4", 40, 1, true, "validated-Peregrine-inf-prop")
