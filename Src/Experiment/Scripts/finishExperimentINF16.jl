include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

finishExperiment("gl", 64, 1, true, "validated-Peregrine-inf-prop")
