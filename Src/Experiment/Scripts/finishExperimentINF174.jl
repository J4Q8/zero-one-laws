include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

finishExperiment("k4", 80, 10, true, "validated-Peregrine-inf-prop")
