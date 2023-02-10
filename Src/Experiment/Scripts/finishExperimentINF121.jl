include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

finishExperiment("gl", 40, 7, true, "validated-Peregrine-inf-prop")
