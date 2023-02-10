include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

finishExperiment("k4", 64, 5, true, "validated-Peregrine-inf-prop")
