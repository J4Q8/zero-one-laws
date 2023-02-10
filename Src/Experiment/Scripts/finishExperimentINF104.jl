include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

finishExperiment("gl", 48, 6, true, "validated-Peregrine-inf-prop")
