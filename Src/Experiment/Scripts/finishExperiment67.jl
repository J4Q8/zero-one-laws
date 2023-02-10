include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

finishExperiment("gl", 40, 4, false, "validated-Peregrine")
