local DEBUG = true

local inspect = require('inspect')
local pd_utils = require('pd_utils')
local array = require('array')
local arg_parser = require('arg_parser')

if not _GLOBALTABLE then
    _GLOBALTABLE = {}
end

local objectname = "larray.print"
local larray = pd.Class:new():register(objectname)


function larray:initialize(sel, atoms)
    if DEBUG then
        package.path = package.path .. ";/home/neum/Documenti/pdlua_externals/larray/?.lua"
    end

    self.selector = atoms[1]
    self.token = pd_utils.get_token()
    self.inlets = 1

    return true
end


function larray:in_1_float(f)
    pd.post(f)
end


function larray:in_1_bang()
    if not self.selector then self.selector = objectname end
    pd.post(string.format("%s %s", self.selector, self.larr:tostr()))
end


function larray:in_1_list()
    self:error(string.format("%s: Please set a larray structure with [ brackets ]", objectname))
end


function larray:in_1_ltable(ref)
    local t_larr = array.deep_copy(_GLOBALTABLE[ref[1]])
    self.larr = pd_utils.table_to_ltable(t_larr)
    self:in_1_bang()
end


function larray:in_1_larray(atoms)
    self.larr = pd_utils.larray_to_ltable(atoms, pd.post, objectname)
    self:in_1_bang()
end


function larray:in_1(sel, atoms)
    local concatenated = array.concat({ sel }, atoms)
    self:in_1_larray(concatenated)
end