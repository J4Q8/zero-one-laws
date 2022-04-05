module Cleaner

export cleanFormula

function cleanFormula(formula::String)
    cleaned = ""
    for c in formula
        cleaned = cleaned * cleanChar(c)
    end
    return cleaned
end

function cleanChar(c::Char)
    if c == '^' || c == '∧' || c == '&'
        #takes care of conjunction
        return '∧'
    elseif c == 'v' || c == 'V' || c == '|' || c == '∨'
        #takes care of disjunction
        return '∨'
    elseif c == '-' || c == '→'
        #takes care of implication "->"
        return '→'
    elseif c == '<' || c == '↔'
        #takes care of bimplication"<>"
        return '↔'
    elseif c == 'b' || c == '◻'
        # takes care of box
        return '◻'
    elseif c == 'd' || c == '◇'
        # takes care of diamond
        return '◇'
    elseif c == '~' || c == '¬'
        # takes care of negation
        return '¬'
    elseif c == 'F' || c == '⊥'
        #takes care of contradiction
        return '⊥'
    elseif c == 'T' || c == '⊤'
        #takes care of truth
        return '⊤'
    elseif c == '(' || c == ')'
        # leaves brackets as they were
        return c
    elseif !isletter(c) || c == '>'
        #removes all characters which cannot be atoms nor they complete "->" or "<>"
        return ""
    else
        # everything else is treated as propositional atom
        return lowercase(c)
    end    
end

end