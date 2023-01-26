include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

finishExperiment("s4", 80, 2, true, "validated-Peregrine-inf-prop")
