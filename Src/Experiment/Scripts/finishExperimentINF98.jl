include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

finishExperiment("k4", 48, 6, true, "validated-Peregrine-inf-prop")
