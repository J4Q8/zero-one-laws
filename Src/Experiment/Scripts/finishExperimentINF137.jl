include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

finishExperiment("k4", 72, 8, true, "validated-Peregrine-inf-prop")
