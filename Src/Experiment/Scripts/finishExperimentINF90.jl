include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

finishExperiment("gl", 80, 5, true, "validated-Peregrine-inf-prop")
