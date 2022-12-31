include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runSelectedFormulasExperiment("k4", 40, true, "validated-Peregrine-inf-prop")
