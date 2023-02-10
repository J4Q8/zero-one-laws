include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

finishExperiment("k4", 80, 9, true, "validated-Peregrine-inf-prop")
