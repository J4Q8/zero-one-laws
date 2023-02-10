include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

finishExperiment("k4", 40, 8, true, "validated-Peregrine-inf-prop")
