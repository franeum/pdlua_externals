local DEBUG = true

local csv = require('ftcsv')
local inspect = require('inspect')
local pd_utils = require('pd_utils')
local array = require('array')
local arg_parser = require('arg_parser')

if not _GLOBALTABLE then
    _GLOBALTABLE = {}
end

local objectname = "larray.read_csv"
local larray = pd.Class:new():register(objectname)


function larray:initialize(sel, atoms)
    if DEBUG then
        package.path = package.path .. ";/home/neum/Documenti/pdlua_externals/larray/?.lua"
    end

    local output = arg_parser.parse(atoms)['@output']
    local separator = arg_parser.parse(atoms)['@sep']
    
    if separator == 'comma' then
        self.separator = ','
    elseif separator == 'semicolon' then
        self.separator = ';'
    else
        self.separator = ','
    end

    pd.post(string.format("separator: %s", separator))
    pd.post(string.format("output: %s", output))
    
    self.token = pd_utils.get_token()
    self.out = self:custom_output(output)

    self.inlets = 1
    self.outlets = 2

    return true
end


function larray:in_1_read(atoms)
    self.data, self.headers = csv.parse(atoms[1], { delimiter=self.separator })
    self.len = self.data
    self:tolarray()
end


function larray:in_1_headers()
    self:outlet(2, 'headers', self.headers )
end


function larray:in_1_col(atoms)
    local data = {}

    for _,v in ipairs(self.data) do
        table.insert(data, v[atoms[1]])
    end

    local column = pd_utils.table_to_ltable(data)
    pd.post(inspect(column))
    
    self:outlet(1, 'larray', pd_utils.ltable_to_larray(column.seq))
end


function larray:tolarray()
    for _, col in ipairs(self.headers) do
        for _, value in ipairs(self.data) do
            pd.post(inspect(value[col]))
        end
    end
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


function larray:in_1_larray(atoms)
    self.larr = pd_utils.larray_to_ltable(atoms, pd.post, objectname)
    self.out()
end


function larray:in_1(sel, atoms)
    pd.post(string.format("%s %s", sel, inspect(atoms)))
    local concatenated = array.concat({ sel }, atoms)
    self:in_1_larray(concatenated)
end


function larray:custom_output(func)
    if func == 'token' or not func then
        return function ()
            _GLOBALTABLE[self.token] = self.larr.seq
            self:outlet(1, 'ltable', { self.token })
        end
    elseif func == 'larray' then
        return function ()
            self:outlet(1, 'larray', pd_utils.ltable_to_larray(self.larr.seq))
        end
    elseif func == 'list' then
        return function ()
            self:outlet(1, 'list', pd_utils.larray_to_list(self.larr.seq))
        end
    end
end