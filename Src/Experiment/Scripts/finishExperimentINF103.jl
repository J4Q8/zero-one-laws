include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

finishExperiment("gl", 40, 6, true, "validated-Peregrine-inf-prop")
