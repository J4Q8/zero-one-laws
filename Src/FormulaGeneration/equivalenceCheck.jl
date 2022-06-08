include(joinpath("..", joinpath("Tableau-solver","interface.jl")))

using .Interface


path = "generated"
formulaPath1 = joinpath(path, "formulas 1")
formulaPath2 = joinpath(path, "formulas 2")

for d in 6:13
    formulasFile1 = joinpath(formulaPath1, "depth "*string(d)*".txt")
    formulasFile2 = joinpath(formulaPath2, "depth "*string(d)*".txt")

    open(formulasFile1) do io1
        open(formulasFile2) do io2
            f_1 = readlines(io1)
            f_2 = readlines(io2)
            for f1 in f_1, f2 in f_2
                if Interface.isEquivalent(Interface.parseFormula(f1), Interface.parseFormula(f2))
                    print("FUUUUUUCK")
                end
            end
        end
    end
end

