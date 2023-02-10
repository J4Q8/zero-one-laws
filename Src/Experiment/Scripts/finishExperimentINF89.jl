include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

finishExperiment("gl", 72, 5, true, "validated-Peregrine-inf-prop")
