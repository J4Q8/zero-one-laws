include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

finishExperiment("k4", 56, 5, true, "validated-Peregrine-inf-prop")
