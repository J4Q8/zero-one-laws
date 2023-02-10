include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

finishExperiment("s4", 40, 2, true, "validated-Peregrine-inf-prop")
