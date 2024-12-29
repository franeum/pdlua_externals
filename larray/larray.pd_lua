local DEBUG = true
local larr = pd.Class:new():register("larray")
local inspect = require('inspect')

function larr:initialize()
    self.reg = require('myregistry')
    if DEBUG then
        self.lex = dofile('/home/neum/Documents/pdlua_externals/larray/larray.lua')
        self.Larray = dofile('/home/neum/Documents/pdlua_externals/larray/Larray.lua')
        --self.registry = dofile('/home/neum/Documents/pdlua_externals/larray/myregistry.so')
    else
        self.lex = require('larray')
        self.Larray = require('Larray')
    end

    self.inlets = 1
    self.outlets = 2

    return true
end


function larr:in_1(sel, atoms)
    local parsed = self.lex.process(sel, atoms, pd.post)
    local larr = self.Larray:new(parsed)
    
    pd.post(inspect(larr.seq))
end

-- get lua table pointer
--[[
function larr:in_1_table(ref)
    local retrieved = self.registry.retrieve(ref)
end
]]--