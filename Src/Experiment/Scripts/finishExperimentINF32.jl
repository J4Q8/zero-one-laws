include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

finishExperiment("gl", 48, 2, true, "validated-Peregrine-inf-prop")
