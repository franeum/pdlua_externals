local DEBUG = true
local utils = {}

if DEBUG then
    package.path = package.path .. ";/home/neum/Documenti/pdlua_externals/larray/?.lua"
end


utils.parser = require('ltable_parser')
utils.ltable = require('ltable')
utils.larray_parser = require('larray_parser')


function utils.larray_to_ltable(sel, atoms, post_callback)
    local larray = utils.parser.parse(sel, atoms, post_callback)
    local ltable = utils.ltable(larray)
    return ltable
end


function utils.ltable_to_larray(_tab)
    local parsed = utils.larray_parser.parse(_tab)
    return parsed
end


function utils.table_to_ltable(_tab)
    local lt = utils.ltable(_tab)
    return lt
end


function utils.larray_to_list(_tab)
    -- TODO
end


--[[
function utils.parse_args(_atoms)
    local _pairs = utils.arg_parser.parse(_atoms)
    local output = _pairs['@output']
end
]]--

function utils.get_token()
    local r_string = ""

    for j=1,2 do
        for i=1, 4 do
            local value = string.char(math.random(97,122))
            r_string = r_string .. value
        end

        for i=1, 4 do
            local value = math.random(0,9)
            r_string = r_string .. value
        end
    end

    return r_string
end


function utils.custom_output(obj, func, _tab, _token)
    if func == 'token' or not func then
        return function ()
            _GLOBALTABLE[_token] = _tab.seq
            obj:outlet(1, 'ltable', { _token })
        end
    elseif func == 'larray' then
        return function ()
            obj:outlet(1, "", utils.ltable_to_larray(_tab.seq))
        end
    elseif func == 'list' then
        return function ()
            obj:outlet(1, 'list', utils.larray_to_list(_tab.seq))
        end
    end
end


return utils