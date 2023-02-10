include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

finishExperiment("gl", 80, 10, true, "validated-Peregrine-inf-prop")
