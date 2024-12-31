local DEBUG = true
local larr = pd.Class:new():register("tastoma")
local inspect = require('inspect')

function larr:initialize(sel, atoms)
    self.reg = require('myregistry')
    if DEBUG then
        self.lex = dofile('/home/neum/Documents/pdlua_externals/larray/larray.lua')
        self.Larray = dofile('/home/neum/Documents/pdlua_externals/larray/Ltable.lua')
    else
        self.lex = require('larray')
        self.Larray = require('Ltable')
    end

    self.registry = require('myregistry')

    self.input_tab = nil
    self.inlets = 1
    self.outlets = 1

    --for i, v in ipairs(atoms) do pd.post(i, v) end

    return true
end


function larr:in_1(sel, atoms)
    local parsed = self.lex.process(sel, atoms, pd.post)
    local larr = self.Larray:new(parsed)
    
    pd.post(inspect(larr.seq))
end


-- get lua table pointer
function larr:in_1_ltable(ref)
    self.input_tab = self.registry.retrieve(ref)
end


function larr:output_ref()
    self:outlet(1, 'ltable')
end