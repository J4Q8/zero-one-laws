include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

finishExperiment("s4", 64, 5, true, "validated-Peregrine-inf-prop")
