include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("s4", 40, 6, true, "validated-Peregrine-inf-prop")
