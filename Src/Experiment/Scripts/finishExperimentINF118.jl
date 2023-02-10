include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

finishExperiment("k4", 64, 7, true, "validated-Peregrine-inf-prop")
