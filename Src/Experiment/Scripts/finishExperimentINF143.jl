include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

finishExperiment("gl", 72, 8, true, "validated-Peregrine-inf-prop")
