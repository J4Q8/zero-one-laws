include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

finishExperiment("k4", 56, 10, true, "validated-Peregrine-inf-prop")
