include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

finishExperiment("gl", 40, 9, true, "validated-Peregrine-inf-prop")
