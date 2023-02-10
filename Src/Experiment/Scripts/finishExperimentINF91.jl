include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

finishExperiment("s4", 40, 6, true, "validated-Peregrine-inf-prop")
