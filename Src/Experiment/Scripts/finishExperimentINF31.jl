include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

finishExperiment("gl", 40, 2, true, "validated-Peregrine-inf-prop")
