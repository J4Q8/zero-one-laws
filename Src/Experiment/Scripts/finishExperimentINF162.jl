include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

finishExperiment("gl", 80, 9, true, "validated-Peregrine-inf-prop")
