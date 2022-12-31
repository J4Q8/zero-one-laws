include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runSelectedFormulasExperiment("k4", 72, true, "validated-Peregrine-inf-prop")
