include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

finishExperiment("k4", 48, 9, true, "validated-Peregrine-inf-prop")
