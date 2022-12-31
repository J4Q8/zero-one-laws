include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runSelectedFormulasExperiment("gl", 72, true, "validated-Peregrine-inf-prop")
