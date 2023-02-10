include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

finishExperiment("s4", 64, 1, true, "validated-Peregrine-inf-prop")
