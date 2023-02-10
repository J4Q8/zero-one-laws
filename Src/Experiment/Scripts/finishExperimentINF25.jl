include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

finishExperiment("k4", 40, 2, true, "validated-Peregrine-inf-prop")
