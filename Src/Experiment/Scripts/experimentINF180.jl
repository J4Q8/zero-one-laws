include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("s4", 80, 10, true, "validated-Peregrine-inf-prop")
