include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

finishExperiment("s4", 40, 3, true, "validated-Peregrine-inf-prop")
