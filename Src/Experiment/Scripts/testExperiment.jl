include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runSelectedFormulasExperiment("s4", 56, true, "validated-Peregrine-inf-prop")
