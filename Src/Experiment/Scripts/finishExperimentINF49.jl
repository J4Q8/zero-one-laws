include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

finishExperiment("gl", 40, 3, true, "validated-Peregrine-inf-prop")
