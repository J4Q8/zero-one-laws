include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

finishExperiment("k4", 80, 8, false, "validated-Peregrine")
