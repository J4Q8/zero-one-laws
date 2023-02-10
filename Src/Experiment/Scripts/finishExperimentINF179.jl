include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

finishExperiment("gl", 72, 10, true, "validated-Peregrine-inf-prop")
