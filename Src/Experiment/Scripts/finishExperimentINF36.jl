include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

finishExperiment("gl", 80, 2, true, "validated-Peregrine-inf-prop")
