include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

finishExperiment("k4", 80, 3, true, "validated-Peregrine-inf-prop")
