include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("s4", 40, 9, true, "validated-Peregrine-inf-prop")
