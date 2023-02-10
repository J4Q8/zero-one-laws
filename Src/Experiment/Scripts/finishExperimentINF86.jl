include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

finishExperiment("gl", 48, 5, true, "validated-Peregrine-inf-prop")
