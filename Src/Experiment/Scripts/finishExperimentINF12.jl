include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

finishExperiment("s4", 80, 3, true, "validated-Peregrine-inf-prop")
