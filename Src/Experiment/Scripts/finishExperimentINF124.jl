include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

finishExperiment("gl", 64, 7, true, "validated-Peregrine-inf-prop")
