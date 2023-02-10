include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

finishExperiment("k4", 64, 2, true, "validated-Peregrine-inf-prop")
