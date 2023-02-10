include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

finishExperiment("gl", 64, 10, true, "validated-Peregrine-inf-prop")
