local Ltable = {}
Ltable.__index = Ltable

setmetatable(Ltable, {
    __call = function (cls, ...)
        local self = setmetatable({}, cls)
        self:init(...)
        return self
    end
    })

local inspect = require('inspect')

function Ltable:init(seq)
    --local mt = {}
    
    self.seq = seq or {}
    return self
end


function Ltable:set_depth(d)
    self.depth = tonumber(d)
end


function Ltable:get_depth()
    return self.depth
end


function Ltable:__tostring()
    local inspect = require("inspect")
    return inspect(self.seq)
end


function Ltable:flat_iterate(s, idx)
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


function Ltable:iterate_table(t, parent_indices)
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


function Ltable:tostr()
    local str = inspect(self.seq)
    str = str:gsub('{','[')
    str = str:gsub('}',']')
    return str
end


return Ltable