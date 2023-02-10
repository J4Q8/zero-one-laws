include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

finishExperiment("gl", 40, 1, true, "validated-Peregrine-inf-prop")
