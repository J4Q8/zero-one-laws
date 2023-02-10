include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

finishExperiment("s4", 64, 9, true, "validated-Peregrine-inf-prop")
