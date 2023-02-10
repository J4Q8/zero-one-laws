include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

finishExperiment("gl", 64, 9, true, "validated-Peregrine-inf-prop")
