include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

finishExperiment("k4", 64, 3, true, "validated-Peregrine-inf-prop")
