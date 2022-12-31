include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runExperiment("s4", 80, 3, true, "validated-Peregrine-inf-prop")
