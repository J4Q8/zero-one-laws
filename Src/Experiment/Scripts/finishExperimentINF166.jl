include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

finishExperiment("s4", 64, 10, true, "validated-Peregrine-inf-prop")
