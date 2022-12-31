include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runSelectedFormulasExperiment("s4", 80, false, "validated-Peregrine")
