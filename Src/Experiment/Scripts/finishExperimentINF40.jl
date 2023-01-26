include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

finishExperiment("s4", 80, 10, true, "validated-Peregrine-inf-prop")
