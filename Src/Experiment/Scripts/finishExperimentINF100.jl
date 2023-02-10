include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

finishExperiment("k4", 64, 6, true, "validated-Peregrine-inf-prop")
