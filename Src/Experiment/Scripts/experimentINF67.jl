include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("s4", 40, 4, true, "validated-Peregrine-inf-prop")
