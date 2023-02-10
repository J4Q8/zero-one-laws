include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

finishExperiment("gl", 64, 2, true, "validated-Peregrine-inf-prop")
