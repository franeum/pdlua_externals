local larray = {}
local patok = require('patok')
local lexer = patok {OPENPAREN = '%{'}
                    {CLOSEPAREN = '%}'}
                    {FLOAT = "%d+%.?%d*"}
                    {SYMBOL = '%w+'}
                    {SEPARATOR = '[%s,]+'}()

local inspect = require('inspect')

-- reset string to parse
local function reset(str)
    return lexer:reset(str)
end


-- iterate over string to parse
local function next()
    return lexer:next()
end


-- parser
local function execute_parse(tokens)
    local tab = {}

    for _, token in ipairs(tokens) do
        if token.type == 'OPENPAREN' then
            table.insert(tab, '[')
        elseif token.type == 'CLOSEPAREN' then
            table.insert(tab, ']')
        elseif token.type == 'SYMBOL' then
            table.insert(tab, token.value)
        elseif token.type == 'FLOAT' then
            table.insert(tab, tonumber(token.value))
        end
    end

    return tab
end


-- lexer
local function lexify(s)
    reset(s)

    --local t = nil
    local tab = {}

    repeat
        local t = next()
        if t then table.insert(tab, t) end
    until not t 

    return tab
end


-- apply lexer and parser
function larray.parse(_tab, callback)
    local s = inspect(_tab)
    local lexed = lexify(s)
    local l_array = execute_parse(lexed, callback)
    return l_array
end


return larray