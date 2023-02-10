include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

finishExperiment("gl", 80, 1, true, "validated-Peregrine-inf-prop")
