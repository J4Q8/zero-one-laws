include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

finishExperiment("k4", 72, 10, true, "validated-Peregrine-inf-prop")
