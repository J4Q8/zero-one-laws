include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

finishExperiment("gl", 48, 3, true, "validated-Peregrine-inf-prop")
