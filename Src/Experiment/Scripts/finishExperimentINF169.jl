include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

finishExperiment("k4", 40, 10, true, "validated-Peregrine-inf-prop")
