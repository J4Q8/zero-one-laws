include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

finishExperiment("k4", 40, 7, true, "validated-Peregrine-inf-prop")
