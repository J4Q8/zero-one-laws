include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

finishExperiment("k4", 72, 4, true, "validated-Peregrine-inf-prop")
