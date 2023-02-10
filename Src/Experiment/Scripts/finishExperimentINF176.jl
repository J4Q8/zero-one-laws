include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

finishExperiment("gl", 48, 10, true, "validated-Peregrine-inf-prop")
