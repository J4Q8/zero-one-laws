include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

finishExperiment("k4", 48, 2, true, "validated-Peregrine-inf-prop")
