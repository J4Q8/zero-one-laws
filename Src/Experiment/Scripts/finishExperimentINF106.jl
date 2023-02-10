include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

finishExperiment("gl", 64, 6, true, "validated-Peregrine-inf-prop")
