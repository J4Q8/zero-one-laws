include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

finishExperiment("s4", 64, 1, false, "validated-Peregrine")
