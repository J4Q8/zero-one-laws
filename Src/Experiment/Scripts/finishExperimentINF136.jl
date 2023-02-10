include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

finishExperiment("k4", 64, 8, true, "validated-Peregrine-inf-prop")
