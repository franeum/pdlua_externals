local larr = pd.Class:new():register("larray")
local inspect = require('inspect')

function larr:initialize(sel, atoms)
    self.reg = require('myregistry')
    --self.inspect = require('inspect')
    self.lex = dofile('/home/neum/Documents/pdlua_externals/larray/larray.lua')
    self.counter = 1
    self.inlets = 1
    self.outlets = 2

    return true
end


function larr:in_1(sel, atoms)
    --[[
    local s = ""
    if sel ~= 'list' then s = tostring(sel) end

    for _,v in ipairs(atoms) do s = s .. " " .. tostring(v) end

    self.lex.reset(s)

    local t = nil
    local tab = {}

    repeat
        t = self.lex.next()
        if t then table.insert(tab, t) end
    until not t 
    ]]--

    local parsed = self.lex.process(sel, atoms)
    pd.post(inspect(parsed))

end