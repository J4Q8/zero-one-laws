include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runSelectedFormulasExperiment("gl", 48, false, "validated-Peregrine")
