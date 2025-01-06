local larray = {}
local patok = require('patok')
local lexer = patok {OPENPAREN = '%['}
                    {CLOSEPAREN = '%]'}
                    {FLOAT = "%d+%.?%d*"}
                    {SYMBOL = '%w+'}
                    {SEPARATOR = '%s+'}()

local DEBUG = false

-- reset string to parse
local function reset(str)
    return lexer:reset(str)
end


-- iterate over string to parse
local function next()
    return lexer:next()
end


-- parser
local function execute_parse(tokens, callback, obj_name)
    local stack = { {} } -- Pila per gestire le tabelle annidate
    local current_table = stack[1] -- La tabella corrente
    local level = 0
    --local depth = 0

    for idx, token in ipairs(tokens) do
        if DEBUG then pd.post(string.format("%s === %s: %s", obj_name, token.type, token.value)) end
        --[[
        if idx == 1 and token.type ~= 'OPENPAREN' then 
            callback(string.format("%s: MALFORMED LARRAY (missing starting bracket)", obj_name))
            return nil
        end]]--
        if token.type == "OPENPAREN" then
            -- Aggiungere una nuova tabella al livello corrente
            level = level + 1
            --depth = math.max(level, depth)
            local new_table = {}
            table.insert(current_table, new_table)
            table.insert(stack, new_table) -- Spingere nella pila
            current_table = new_table
        elseif token.type == "CLOSEPAREN" then
            -- Tornare al livello precedente
            level = level - 1
            if level == 0 and idx ~= #tokens then 
                callback(string.format("%s: MALFORMED LARRAY (missing 0-level brackets)", obj_name))
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

    return stack[1][1]
end


-- list to string
local function stringify(atoms)
    --[[
    local s = ""

    if sel ~= 'list' then s = tostring(sel) end
    for _,v in ipairs(atoms) do s = s .. " " .. tostring(v) end
    return s]]--
    local s = ''
    for i, v in ipairs(atoms) do
        if i == 1 then 
            s = tostring(v) 
        else
            s = s .. " " .. tostring(v)
        end
    end
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
function larray.parse(atoms, callback, object_name)
    --local inspect = require("inspect")
    local s = stringify(atoms)
    local lexed = lexify(s)
    local ltable = execute_parse(lexed, callback, object_name)
    return ltable
end


return larray