include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

finishExperiment("s4", 40, 8, true, "validated-Peregrine-inf-prop")
