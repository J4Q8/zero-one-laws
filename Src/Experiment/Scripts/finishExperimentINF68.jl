include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

finishExperiment("gl", 48, 4, true, "validated-Peregrine-inf-prop")
