include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("s4", 40, 5, true, "validated-Peregrine-inf-prop")
