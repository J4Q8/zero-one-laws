include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

finishExperiment("k4", 40, 1, true, "validated-Peregrine-inf-prop")
