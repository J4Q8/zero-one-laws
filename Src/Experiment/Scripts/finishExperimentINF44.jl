include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

finishExperiment("k4", 48, 3, true, "validated-Peregrine-inf-prop")
