include(joinpath("..","experimentalSetup.jl"))

using .ExperimentalSetup

runSelectedFormulasExperiment("s4", 40, true, "validated-Peregrine-inf-prop")
