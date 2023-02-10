include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

finishExperiment("gl", 48, 8, true, "validated-Peregrine-inf-prop")
