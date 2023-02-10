include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

finishExperiment("gl", 80, 3, true, "validated-Peregrine-inf-prop")
