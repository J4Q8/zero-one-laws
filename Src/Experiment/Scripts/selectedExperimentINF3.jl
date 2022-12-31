include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runSelectedFormulasExperiment("gl", 56, true, "validated-Peregrine-inf-prop")
