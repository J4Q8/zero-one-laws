include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

finishExperiment("gl", 72, 4, true, "validated-Peregrine-inf-prop")
