local DEBUG = true
local larr = pd.Class:new():register("larray")
local inspect = require('inspect')
local pd_utils= require('pd_utils')

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

    self.inlets = 1
    self.outlets = 2

    return true
end


function larr:in_1(sel, atoms)
    larr = pd_utils.larray_to_ltable(sel, atoms, pd.post)
    pd.post(inspect(larr))
end


-- get lua table pointer
function larr:in_1_table(ref)
    self.input_tab = self.registry.retrieve(ref)
    -- process
end


function larr:output_ref()
    self:outlet(1, 'ltable')
end