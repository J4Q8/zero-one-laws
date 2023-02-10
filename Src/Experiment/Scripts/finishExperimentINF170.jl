include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

finishExperiment("k4", 48, 10, true, "validated-Peregrine-inf-prop")
