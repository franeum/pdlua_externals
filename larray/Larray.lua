local Larray = {}
Larray.__index = Larray

local inspect = require('inspect')

function Larray:new(seq)
    local mt = {}
    if seq then mt.seq = seq end
    --if depth then mt.depth = depth end
    setmetatable(mt, self)
    return mt
end

--[[
function Larray:set_depth(d)
    self.depth = tonumber(d)
end

function Larray:get_depth()
    return self.depth
end
]]--

function Larray:__tostring()
    local inspect = require("inspect")
    return inspect(self.seq)
end

function Larray:flat_iterate(s, idx)
    local _idx

    if not idx then
        _idx = 1
    end

    for i, v in ipairs(s) do
        if type(v) ~= 'table' then
            print(i, v)
        else
            self:flat_iterate(v, _idx)
        end
    end
end


function Larray:iterate_table(t, parent_indices)
    parent_indices = parent_indices or {}
    for i, v in ipairs(t) do
        local current_indices = {table.unpack(parent_indices)}
        table.insert(current_indices, i)

        if type(v) == "table" then
            self:iterate_table(v, current_indices)
        else
            print(table.concat(current_indices, " "), v)
        end
    end
end


function Larray:tostr()
    local str = inspect(self.seq)
    str = str:gsub('{','[')
    str = str:gsub('}',']')
    return str
end


return Larray