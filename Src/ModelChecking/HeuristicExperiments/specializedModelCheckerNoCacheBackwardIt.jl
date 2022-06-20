module SpecializedModelChecker

using ..Trees
using ..Parser
using ..Simplifier
using ..KRStructures

export checkModelValidity!, checkFrameValidity, serialCheckModelValidity, serialCheckFrameValidity

TESTMODE = true

function checkTF(t::Tree)
    if t.connective in ['⊤','⊥'] && isdefined(t, :left) && isdefined(t, :right)
        error("This should be a leaf but is:", t)
    end
end

function cacheFormula!(model::KRStructure, layer::Int64, world::Int64, formula::Tree, result::Bool)
    # IMPORTANT
    # we cache only the children, because the top most formula is never checked again in the same world
    # model.worlds[layer][world][formula] = result ? '⊤' : '⊥'
end

function simplifyInWorldRec(world::Dict{Tree, Char}, formula::Tree)
    if TESTMODE
        checkTF(formula)
    end

    if haskey(world, formula)
        return Tree(world[formula])
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

function checkConj!(model::KRStructure, formula::Tree, layer::Int64, world::Int64)
    # short circuited OR implemented manually (needed to save the formulas)
    lh = checkFormula!(model, formula.left, layer, world)
    cacheFormula!(model, layer, world, formula.left, lh)
    if lh
        return true
    else
        rh = checkFormula!(model, formula.right, layer, world)
        cacheFormula!(model, layer, world, formula.right, rh)
        return rh
    end
end

function checkDisj!(model::KRStructure, formula::Tree, layer::Int64, world::Int64)
    lh = checkFormula!(model, formula.left, layer, world)
    cacheFormula!(model, layer, world, formula.left, lh)
    if !lh
        return false
    else
        rh = checkFormula!(model, formula.right, layer, world)
        cacheFormula!(model, layer, world, formula.right, rh)
        return rh
    end
end

function checkImp!(model::KRStructure, formula::Tree, layer::Int64, world::Int64)
    lh = checkFormula!(model, formula.left, layer, world)
    cacheFormula!(model, layer, world, formula.left, lh)

    rh = checkFormula!(model, formula.right, layer, world)
    cacheFormula!(model, layer, world, formula.right, rh)
    if !lh || rh
        return true
    else
        return false
    end
end

function checkBiImp!(model::KRStructure, formula::Tree, layer::Int64, world::Int64)
    lh = checkFormula!(model, formula.left, layer, world)
    cacheFormula!(model, layer, world, formula.left, lh)
    rh = checkFormula!(model, formula.right, layer, world)
    cacheFormula!(model, layer, world, formula.right, rh)
    if lh == rh
        return true
    else
        return false
    end
end

function checkNeg!(model::KRStructure, formula::Tree, layer::Int64, world::Int64)
    rh = checkFormula!(model, formula.right, layer, world)
    cacheFormula!(model, layer, world, formula.right, rh)
    return !rh
end

function diaHelper!(model::KRStructure, formula::Tree, relation::String)
    #we don't have to save e.g. model.worlds[1][world][formula] = '⊤' because it will be used only in the first
    # I am aware that this could be made more flexible, but I intend to maximize the speed of execution, 
    # for general model checker look at ModelChecker
    if relation == "r12"
        accessibleWorlds = [w[2] for w in findall(model.r12)]
        layer = 2
    elseif relation == "r13"
        accessibleWorlds = [w[2] for w in findall(model.r13)]
        layer = 3
    elseif relation == "r23"
        accessibleWorlds = [w[2] for w in findall(model.r23)]
        layer = 3
    end

    for a in accessibleWorlds
        if checkFormula!(model, formula.right, layer, a)
            cacheFormula!(model, layer, a, formula.right, true)
            return true
        else
            cacheFormula!(model, layer, a, formula.right, false)
        end
    end 
    return false
end

function diaHelperReflexivity!(model::KRStructure, formula::Tree)
    if model.class == "k4"
        mode = 2
    elseif model.class == "s4"
        mode = 1
    else
        return false
    end

    for (idx, l) in enumerate(model.worlds), idx2 in 1:length(l)
        if mod(idx2, mode) == 0
            if checkFormula!(model, formula.right, idx, idx2)
                cacheFormula!(model, idx, idx2, formula.right, true)
                return true
            else
                cacheFormula!(model, idx, idx2, formula.right, false)
            end
        end
    end
    return false
end


function checkDia!(model::KRStructure, formula::Tree, layer::Int64, world::Int64)
    #we don't have to save e.g. model.worlds[1][world][formula] = '⊤' because it will be used only in the first
    if layer == 1

        if diaHelper!(model, formula, "r12") || diaHelper!(model, formula, "r13")
            return true
        end
        
    elseif layer == 2
        
        if diaHelper!(model, formula, "r23")
            return true
        end
    end

    if diaHelperReflexivity!(model, formula)
        return true
    end

    cacheFormula!(model, layer, world, formula, false)
    return false
end

function boxHelper!(model::KRStructure, formula::Tree, relation::String)
    #we don't have to save e.g. model.worlds[1][world][formula] = '⊤' because it will be used only in the first
    # I am aware that this could be made more flexible, but I intend to maximize the speed of execution, 
    # for general model checker look at ModelChecker
    if relation == "r12"
        accessibleWorlds = [w[2] for w in findall(model.r12)]
        layer = 2
    elseif relation == "r13"
        accessibleWorlds = [w[2] for w in findall(model.r13)]
        layer = 3
    elseif relation == "r23"
        accessibleWorlds = [w[2] for w in findall(model.r23)]
        layer = 3
    end

    for a in accessibleWorlds
        if !checkFormula!(model, formula.right, layer, a)
            model.worlds[layer][a][formula.right] = '⊥'
            return false
        else
            model.worlds[layer][a][formula.right] = '⊤'
        end
    end 
    return true
end

function boxHelperReflexivity!(model::KRStructure, formula::Tree)
    if model.class == "k4"
        mode = 2
    elseif model.class == "s4"
        mode = 1
    else
        return true
    end

    for (idx, l) in enumerate(model.worlds), idx2 in 1:length(l)
        if mod(idx2, mode) == 0
            if !checkFormula!(model, formula.right, idx, idx2)
                cacheFormula!(model, idx, idx2, formula.right, false)
                return false
            else
                cacheFormula!(model, idx, idx2, formula.right, true)
            end
        end
    end
    return true
end


function checkBox!(model::KRStructure, formula::Tree, layer::Int64, world::Int64)
    if layer == 1

        if !(boxHelper!(model, formula, "r12") && boxHelper!(model, formula, "r13"))
            return false
        end

    elseif layer == 2
        
        if !boxHelper!(model, formula, "r23")
            return false
        end

    end

    if !boxHelperReflexivity!(model, formula)
        return false
    end
    
    cacheFormula!(model, layer, world, formula, true)
    return true
end


function checkFormula!(model::KRStructure, formula::Tree, layer::Int64, world::Int64)
    formula = simplifyInWorld(model.worlds[layer][world], formula)
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
    error("You reached the end of the switch statement. You shouldn't be here.\n Atoms should have been replaced with their valuations before, however we got: ", formula)
end

function checkModelValidity!(model::KRStructure, formula::Tree)
    # design choice evaluate from the upper layer as it will faster rule out formulas starting with box
    for (lidx, layer) in enumerate(model.worlds[end:-1:1])
        for (widx, _) in enumerate(layer)
            if !checkFormula!(model, formula, lidx, widx)
                return false
            end
        end
    end
    return true
end

function checkFrameValidity(model::KRStructure, formula::Tree, nValuations::Int64)
    for _ in 1:nValuations
        model_copy = deepcopy(model)
        addRandomValuations!(model_copy)
        if !checkModelValidity!(model_copy, formula)
            return false
        end
    end
    return true
end

function serialCheckModelValidity(formula::Tree, language::String, nodes::Int64, nModels::Int64)
    validCount = 0
    for _ in 1:nModels
        model = generateModel(nodes, language)
        if checkModelValidity!(model, formula)
            validCount = validCount + 1
        end
    end
    return validCount
end

function serialCheckFrameValidity(formula::Tree, language::String, nodes::Int64, nModels::Int64, nFrames::Int64)
    validCount = 0
    for _ in 1:nFrames
        frame = generateFrame(nodes, language)
        if checkFrameValidity(frame, formula, nModels)
            validCount = validCount + 1
        end
    end
    return validCount
end

# @time begin
#     for _ in 1:10000
#         model = generateModel(80, "gl")
#         if !checkModelValidity!(model, parseFormula("bbbF"))
#             println("Oooops")
#         end
#     end
# end


end #module