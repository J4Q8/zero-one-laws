include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("s4", 80, 5, true, "validated-Peregrine-inf-prop")
