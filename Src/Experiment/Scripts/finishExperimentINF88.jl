include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

finishExperiment("gl", 64, 5, true, "validated-Peregrine-inf-prop")
