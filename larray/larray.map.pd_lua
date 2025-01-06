local DEBUG = true

local inspect = require('inspect')
local pd_utils = require('pd_utils')
local array = require('array')
local arg_parser = require('arg_parser')

if not _GLOBALTABLE then
    _GLOBALTABLE = {}
end

local objectname = "larray.map"
local larray = pd.Class:new():register(objectname)


function larray:initialize(sel, atoms)
    if DEBUG then
        package.path = package.path .. ";/home/neum/Documenti/pdlua_externals/larray/?.lua"
    end

    local output = arg_parser.parse(atoms)['@output']
    self.token = pd_utils.get_token()
    self.out = self:custom_output(output)
    
    self.inlets = 1
    self.outlets = 1

    return true
end


function larray:in_1_float(f)
    self:outlet(1, 'float', { f })
end


function larray:in_1_list()
    self:error(string.format("%s: Please set a larray structure with [ brackets ]", objectname))
end


function larray:in_1_ltable(ref)
    local t_larr = array.deep_copy(_GLOBALTABLE[ref[1]])
    self.larr = pd_utils.table_to_ltable(t_larr)
    self.out()
end


function larray:in_1(sel, atoms)
    --pd.post(inspect(atoms))
    self.larr = pd_utils.larray_to_ltable(sel, atoms, pd.post, objectname)
    
    for _,v in ipairs(self.larr.seq) do
        if type(v) == 'number' then
            self:outlet(1, 'float', { v })
        elseif type(v) == 'string' then
            self:outlet(1, 'symbol', { v })
        end
    end
end


function larray:custom_output(func)
    if func == 'token' or not func then
        return function ()
            _GLOBALTABLE[self.token] = self.larr.seq
            self:outlet(1, 'ltable', { self.token })
        end
    elseif func == 'larray' then
        return function ()
            self:outlet(1, "", pd_utils.ltable_to_larray(self.larr.seq))
        end
    elseif func == 'list' then
        return function ()
            self:outlet(1, 'list', pd_utils.larray_to_list(self.larr.seq))
        end
    end
end