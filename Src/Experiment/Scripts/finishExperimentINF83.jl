include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

finishExperiment("k4", 72, 5, true, "validated-Peregrine-inf-prop")
