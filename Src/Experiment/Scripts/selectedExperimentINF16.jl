include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runSelectedFormulasExperiment("s4", 64, true, "validated-Peregrine-inf-prop")
