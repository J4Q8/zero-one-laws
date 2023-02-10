include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

finishExperiment("k4", 80, 6, true, "validated-Peregrine-inf-prop")
