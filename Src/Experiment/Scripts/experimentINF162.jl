include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("s4", 80, 9, true, "validated-Peregrine-inf-prop")
