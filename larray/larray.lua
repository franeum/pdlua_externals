local larray = {}
local patok = require('patok')
local lexer = patok {OPENPAREN = '%['}
                    {CLOSEPAREN = '%]'}
                    {FLOAT = "%d+%.?%d*"}
                    {SYMBOL = '%w+'}
                    {SEPARATOR = '%s+'}()



-- reset string to parse
local function reset(str)
    return lexer:reset(str)
end


-- iterate over string to parse
local function next()
    return lexer:next()
end


-- parser
local function parse(tokens, callback)
    local stack = { {} } -- Pila per gestire le tabelle annidate
    local current_table = stack[1] -- La tabella corrente
    local level = 0
    local depth = 0

    for idx, token in ipairs(tokens) do
        if idx == 1 and token.type ~= 'OPENPAREN' then 
            callback("MALFORMED LARRAY (missing starting bracket)")
            return nil
        end
        if token.type == "OPENPAREN" then
            -- Aggiungere una nuova tabella al livello corrente
            level = level + 1
            depth = math.max(level, depth)
            local new_table = {}
            table.insert(current_table, new_table)
            table.insert(stack, new_table) -- Spingere nella pila
            current_table = new_table
        elseif token.type == "CLOSEPAREN" then
            -- Tornare al livello precedente
            level = level - 1
            if level == 0 and idx ~= #tokens then 
                callback("MALFORMED LARRAY (missing 0-level brackets)")
                return nil
            end
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

    return stack[1][1], depth
end


-- list to string
local function stringify(sel, atoms)
    local s = ""

    if sel ~= 'list' then s = tostring(sel) end
    for _,v in ipairs(atoms) do s = s .. " " .. tostring(v) end
    return s
end


-- lexer
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


-- apply lexer and parser
function larray.process(sel, atoms, callback)
    local s = stringify(sel, atoms)
    local lexed = lexify(s)
    local ltable, depth = parse(lexed, callback)
    return ltable, depth
end


return larray