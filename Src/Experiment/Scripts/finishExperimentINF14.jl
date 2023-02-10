include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

finishExperiment("gl", 48, 1, true, "validated-Peregrine-inf-prop")
