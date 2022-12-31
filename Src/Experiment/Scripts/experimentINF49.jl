include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("s4", 40, 3, true, "validated-Peregrine-inf-prop")
