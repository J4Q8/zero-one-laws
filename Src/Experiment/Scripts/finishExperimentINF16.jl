include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

finishExperiment("s4", 80, 4, true, "validated-Peregrine-inf-prop")
