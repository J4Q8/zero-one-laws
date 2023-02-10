include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

finishExperiment("s4", 40, 4, true, "validated-Peregrine-inf-prop")
