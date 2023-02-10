include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

finishExperiment("k4", 64, 10, true, "validated-Peregrine-inf-prop")
