module ModelChecker

include("../FormulaUtils/trees.jl")
include("../FormulaUtils/cleaner.jl")
include("../FormulaUtils/parser.jl")
include("../FormulaUtils/simplifier.jl")
include("structures.jl")

using .Trees
using .Parser
using .Simplifier
using .Structures

TESTMODE = true

function checkTF(t::Tree)
    if t.connective in ['⊤','⊥'] && isdefined(t, :left) && isdefined(t, :right)
        error("This should be a leaf but is:", t)
    end
end

function simplifyInWorldRec(world::Dict{Tree, Char}, formula::Tree)
    if TESTMODE
        checkTF(formula)
    end

    if haskey(world, formula)
        return world[formula]
    elseif formula.connective ∉ ['◻', '◇']
        root = Tree(formula.connective)
        if isdefined(formula, :left)
            addleftchild!(root, simplifyInWorldRec(world, formula.left))
        end
        if isdefined(formula, :right)
            addrightchild!(root, simplifyInWorldRec(world, formula.right))
        end
        return root
    else
        return formula
    end
end

function simplifyInWorld(world::Dict{Tree, Char}, formula::Tree)
    formula = simplifyInWorldRec(world, formula)
    return simplify(formula)
end

function checkConj!(model::KRModel, formula::Tree, layer::Int64, world::Int64)
    # short circuited OR implemented manually (needed to save the formulas)
    lh = checkFormula!(model, formula.left, layer, world)
    model.worlds[layer][world][formula.left] = lh ? '⊤' : '⊥'
    if lh
        model.worlds[layer][world][formula] = '⊤'
        return true
    else
        rh = checkFormula!(model, formula.right, layer, world)
        model.worlds[layer][world][formula.right] = rh ? '⊤' : '⊥'
        model.worlds[layer][world][formula] = rh ? '⊤' : '⊥'
        return rh
    end
end

function checkDisj!(model::KRModel, formula::Tree, layer::Int64, world::Int64)
    lh = checkFormula!(model, formula.left, layer, world)
    model.worlds[layer][world][formula.left] = lh ? '⊤' : '⊥'
    if !lh
        model.worlds[layer][world][formula] = '⊥'
        return false
    else
        rh = checkFormula!(model, formula.right, layer, world)
        model.worlds[layer][world][formula.right] = rh ? '⊤' : '⊥'
        model.worlds[layer][world][formula] = rh ? '⊤' : '⊥'
        return rh
    end
end

function checkImp!(model::KRModel, formula::Tree, layer::Int64, world::Int64)
    lh = checkFormula!(model, formula.left, layer, world)
    model.worlds[layer][world][formula.left] = lh ? '⊤' : '⊥'
    rh = checkFormula!(model, formula.right, layer, world)
    model.worlds[layer][world][formula.right] = rh ? '⊤' : '⊥'
    if !lh || rh
        model.worlds[layer][world][formula] = '⊤'
        return true
    else
        model.worlds[layer][world][formula] = '⊥'
        return false
    end
end

function checkBiImp!(model::KRModel, formula::Tree, layer::Int64, world::Int64)
    lh = checkFormula!(model, formula.left, layer, world)
    model.worlds[layer][world][formula.left] = lh ? '⊤' : '⊥'
    rh = checkFormula!(model, formula.right, layer, world)
    model.worlds[layer][world][formula.right] = rh ? '⊤' : '⊥'
    if lh == rh
        model.worlds[layer][world][formula] = '⊤'
        return true
    else
        model.worlds[layer][world][formula] = '⊥'
        return false
    end
end

function checkNeg!(model::KRModel, formula::Tree, layer::Int64, world::Int64)
    lh = checkFormula!(model, formula.right, layer, world)
    model.worlds[layer][world][formula.right] = lh ? '⊤' : '⊥'
    model.worlds[layer][world][formula] = !lh ? '⊤' : '⊥'
    return !lh
end


function checkDia!(model::KRModel, formula::Tree, layer::Int64, world::Int64)
    if layer == 1
        accessibleWorlds = [w[2] for w in findall(model.r12)]

        for a in accessibleWorlds
            if checkFormula!(model, formula.right, 2, a)
                model.worlds[2][a][formula.right] = '⊤'
                return true
            else
                model.worlds[2][a][formula.right] = '⊥'
            end
        end 

        accessibleWorlds = [w[2] for w in findall(model.r13)]

        for a in accessibleWorlds
            if checkFormula!(model, formula.right, 3, a)
                model.worlds[3][a][formula.right] = '⊤'
                return true
            else
                model.worlds[3][a][formula.right] = '⊥'
            end
        end 

    elseif layer == 2
        
        accessibleWorlds = [w[2] for w in findall(model.r23)]

        for a in accessibleWorlds
            if checkFormula!(model, formula.right, 3, a)
                model.worlds[3][a][formula.right] = '⊤'
                return true
            else
                model.worlds[3][a][formula.right] = '⊥'
            end
        end 
    end
    model.worlds[layer][world][formula] = '⊥'
    return false
end


function checkBox!(model::KRModel, formula::Tree, layer::Int64, world::Int64)
    if layer == 1
        accessibleWorlds = [w[2] for w in findall(model.r12)]

        for a in accessibleWorlds
            if !checkFormula!(model, formula.right, 2, a)
                model.worlds[2][a][formula.right] = '⊥'
                return false
            else
                model.worlds[2][a][formula.right] = '⊤'
            end
        end 

        accessibleWorlds = [w[2] for w in findall(model.r13)]

        for a in accessibleWorlds
            if !checkFormula!(model, formula.right, 3, a)
                model.worlds[3][a][formula.right] = '⊥'
                return false
            else
                model.worlds[3][a][formula.right] = '⊤'
            end
        end 

    elseif layer == 2
        
        accessibleWorlds = [w[2] for w in findall(model.r23)]

        for a in accessibleWorlds
            if checkFormula!(model, formula.right, 3, a)
                model.worlds[3][a][formula.right] = '⊥'
                return false
            else
                model.worlds[3][a][formula.right] = '⊤'
            end
        end 
    end
    model.worlds[layer][world][formula] = '⊤'
    return true
end


function checkFormula!(model::KRModel, formula::Tree, layer::Int64, world::Int64)
    formula = simplifyInWorld(world, formula)
    if formula.connective == '∨'
        return checkConj!(model, formula, layer, world)
    elseif formula.connective == '∧'
        return checkDisj!(model, formula, layer, world)
    elseif formula.connective == '→'
        return checkImp!(model, formula, layer, world)
    elseif formula.connective == '↔'
        return checkBiImp!(model, formula, layer, world)
    elseif formula.connective == '¬'
        return checkNeg!(model, formula, layer, world)
    elseif formula.connective == '◇'
        return checkDia!(model, formula, layer, world)
    elseif formula.connective == '◻'
        return checkBox!(model, formula, layer, world)
    elseif formula.connective == '⊤'
        return true
    elseif formula.connective == '⊥'
        return false
    end
    error("You shouldn't be here, atoms should have been replaced with their valuations before")
end

function checkModelValidity!(model::KRModel, formula::Tree)
    for (lidx, layer) in enumerate(model.worlds)
        for (widx, _) in enumerate(layer)
            if !checkFormula!(model, formula, lidx, widx)
                return false
            end
        end
    end
    return true
end
end #module