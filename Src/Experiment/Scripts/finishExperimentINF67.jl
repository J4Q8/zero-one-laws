include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

finishExperiment("gl", 40, 4, true, "validated-Peregrine-inf-prop")
