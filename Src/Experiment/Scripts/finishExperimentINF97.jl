include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

finishExperiment("k4", 40, 6, true, "validated-Peregrine-inf-prop")
