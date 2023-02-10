include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

finishExperiment("k4", 48, 4, true, "validated-Peregrine-inf-prop")
