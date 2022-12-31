include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runSelectedFormulasExperiment("k4", 80, true, "validated-Peregrine-inf-prop")
