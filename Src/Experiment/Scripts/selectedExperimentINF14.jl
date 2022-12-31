include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runSelectedFormulasExperiment("s4", 48, true, "validated-Peregrine-inf-prop")
