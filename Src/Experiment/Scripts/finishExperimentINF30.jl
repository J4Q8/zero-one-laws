include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

finishExperiment("k4", 80, 2, true, "validated-Peregrine-inf-prop")
