include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

finishExperiment("gl", 80, 4, true, "validated-Peregrine-inf-prop")
