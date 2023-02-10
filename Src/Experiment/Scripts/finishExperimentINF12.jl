include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

finishExperiment("k4", 80, 1, true, "validated-Peregrine-inf-prop")
