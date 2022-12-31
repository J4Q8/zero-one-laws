include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runSelectedFormulasExperiment("gl", 80, true, "validated-Peregrine-inf-prop")
