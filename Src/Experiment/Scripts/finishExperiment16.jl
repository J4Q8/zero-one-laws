include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

finishExperiment("gl", 64, 1, false, "validated-Peregrine")
