include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

finishExperiment("gl", 40, 8, true, "validated-Peregrine-inf-prop")
