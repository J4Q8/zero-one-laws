include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

finishExperiment("k4", 64, 4, true, "validated-Peregrine-inf-prop")
