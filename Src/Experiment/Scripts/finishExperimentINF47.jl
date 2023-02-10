include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

finishExperiment("k4", 72, 3, true, "validated-Peregrine-inf-prop")
