include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("s4", 40, 10, true, "validated-Peregrine-inf-prop")
