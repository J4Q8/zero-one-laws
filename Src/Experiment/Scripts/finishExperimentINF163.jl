include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

finishExperiment("s4", 40, 10, true, "validated-Peregrine-inf-prop")
