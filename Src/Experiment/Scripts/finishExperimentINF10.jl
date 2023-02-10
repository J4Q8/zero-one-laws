include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

finishExperiment("k4", 64, 1, true, "validated-Peregrine-inf-prop")
