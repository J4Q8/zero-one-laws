include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

finishExperiment("s4", 80, 8, true, "validated-Peregrine-inf-prop")
