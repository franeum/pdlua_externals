local DEBUG = true
local larr = pd.Class:new():register("larray.lookup")
local inspect = require('inspect')

function larr:initialize()
    self.reg = require('myregistry')
    if DEBUG then
        self.lex = dofile('/home/neum/Documents/pdlua_externals/larray/larray.lua')
        self.Larray = dofile('/home/neum/Documents/pdlua_externals/larray/Ltable.lua')
    else
        self.lex = require('larray')
        self.Larray = require('Ltable')
    end

    self.registry = require('myregistry')

    self.inlets = 2
    self.outlets = 2

    return true
end


function larr:in_2(sel, atoms)
    local parsed = self.lex.process(sel, atoms, pd.post)
    self.larr = self.Larray:new(parsed)
    
    pd.post(inspect(self.larr.seq))
end


function larr:in_1_float(f)
    pd.post(inspect(self.larr.seq[f]))
end


-- get lua table pointer
function larr:in_1_table(ref)
    local retrieved = self.registry.retrieve(ref)
end