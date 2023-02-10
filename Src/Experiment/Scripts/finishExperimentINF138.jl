include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

finishExperiment("k4", 80, 8, true, "validated-Peregrine-inf-prop")
