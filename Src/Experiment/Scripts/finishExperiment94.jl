include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

finishExperiment("s4", 64, 6, false, "validated-Peregrine")
