include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("s4", 40, 2, true, "validated-Peregrine-inf-prop")
