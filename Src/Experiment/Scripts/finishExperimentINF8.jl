include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

finishExperiment("k4", 48, 1, true, "validated-Peregrine-inf-prop")
