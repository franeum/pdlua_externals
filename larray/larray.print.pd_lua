local DEBUG = true
local larr = pd.Class:new():register("larray.print")
local inspect = require('inspect')

function larr:initialize()
    self.reg = require('myregistry')
    if DEBUG then
        self.lex = dofile('/home/neum/Documents/pdlua_externals/larray/larray.lua')
        self.Larray = dofile('/home/neum/Documents/pdlua_externals/larray/Larray.lua')
    else
        self.lex = require('larray')
        self.Larray = require('Larray')
    end

    self.registry = require('myregistry')

    self.inlets = 1
    self.outlets = 0

    return true
end


function larr:in_1(sel, atoms)
    local parsed = self.lex.process(sel, atoms, pd.post)
    self.larr = self.Larray:new(parsed)

    local str = self.larr:tostr()

    pd.post(str)
end


-- get lua table pointer
function larr:in_1_table(ref)
    local retrieved = self.registry.retrieve(ref)
    self.larr = self.Larray:new(retrieved)
    local str = self.larr:tostr()

    pd.post(str)
end