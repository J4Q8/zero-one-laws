include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

finishExperiment("gl", 80, 6, true, "validated-Peregrine-inf-prop")
