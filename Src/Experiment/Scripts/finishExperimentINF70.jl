include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

finishExperiment("gl", 64, 4, true, "validated-Peregrine-inf-prop")
