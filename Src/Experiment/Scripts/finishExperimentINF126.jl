include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

finishExperiment("gl", 80, 7, true, "validated-Peregrine-inf-prop")
