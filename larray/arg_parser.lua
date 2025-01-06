local args = {}

local array = require('array')

function args.parse(atoms)
    local t = array.from_pairs(array.chunk(atoms, 2))
    return t
end

return args