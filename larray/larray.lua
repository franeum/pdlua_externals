local larray = {}
local patok = require('patok')
local lexer = patok {OPENPAREN = '%['}
                    {CLOSEPAREN = '%]'}
                    {FLOAT = "%d+%.?%d*"}
                    {SYMBOL = '%w+'}
                    {SEPARATOR = '%s+'}()

local function clean(t)
    table.remove(t, 1)
    table.remove(t, #t)
    return t
end

local function reset(str) 
    return lexer:reset(str)
end

local function next()
    return lexer:next()
end

local function parse(t)
    local tokens = clean(t)
    local stack = { {} } -- Pila per gestire le tabelle annidate
    local current_table = stack[1] -- La tabella corrente
  
    for _, token in ipairs(tokens) do
        if token.type == "OPENPAREN" then
            -- Aggiungere una nuova tabella al livello corrente
            local new_table = {}
            table.insert(current_table, new_table)
            table.insert(stack, new_table) -- Spingere nella pila
            current_table = new_table
        elseif token.type == "CLOSEPAREN" then
            -- Tornare al livello precedente
            table.remove(stack)
            current_table = stack[#stack]
        elseif token.type ~= "SEPARATOR" then
            if token.type == 'SYMBOL' then
                table.insert(current_table, token.value)
            elseif token.type == 'FLOAT' then
                table.insert(current_table, tonumber(token.value))
            end
        end
    end
    return stack[1] -- Restituire la tabella radice
end


local function stringify(sel, atoms)
    local s = ""

    if sel ~= 'list' then s = tostring(sel) end
    
    for _,v in ipairs(atoms) do s = s .. " " .. tostring(v) end
    
    return s
end


local function lexify(s)
    reset(s)

    local t = nil
    local tab = {}

    repeat
        t = next()
        if t then table.insert(tab, t) end
    until not t 

    return tab
end

function larray.process(sel, atoms)
    local s = stringify(sel, atoms)
    local lexed = lexify(s)
    local parsed = parse(lexed)
    return parsed
end


return larray