include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("s4", 40, 8, true, "validated-Peregrine-inf-prop")
