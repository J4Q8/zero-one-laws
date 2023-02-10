include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

finishExperiment("s4", 64, 2, true, "validated-Peregrine-inf-prop")
