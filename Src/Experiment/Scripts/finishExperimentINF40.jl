include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

finishExperiment("s4", 64, 3, true, "validated-Peregrine-inf-prop")
