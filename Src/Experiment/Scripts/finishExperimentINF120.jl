include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

finishExperiment("k4", 80, 7, true, "validated-Peregrine-inf-prop")
