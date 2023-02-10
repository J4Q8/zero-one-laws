include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

finishExperiment("k4", 40, 3, true, "validated-Peregrine-inf-prop")
