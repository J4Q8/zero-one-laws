include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

finishExperiment("s4", 40, 5, true, "validated-Peregrine-inf-prop")
