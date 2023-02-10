include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

finishExperiment("gl", 64, 3, true, "validated-Peregrine-inf-prop")
