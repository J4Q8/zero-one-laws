include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

finishExperiment("gl", 40, 10, true, "validated-Peregrine-inf-prop")
