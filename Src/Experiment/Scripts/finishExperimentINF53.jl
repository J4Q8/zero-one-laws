include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

finishExperiment("gl", 72, 3, true, "validated-Peregrine-inf-prop")
