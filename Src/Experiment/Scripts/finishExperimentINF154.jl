include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

finishExperiment("k4", 64, 9, true, "validated-Peregrine-inf-prop")
