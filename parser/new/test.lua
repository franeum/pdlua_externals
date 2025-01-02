
package.cpath = package.cpath .. ";/home/neum/Documenti/pdlua_externals/parser/new/?.so"
local parser = require("parser")

local input = "[ 1 3 'pippo' [ 7 8 ] 13.6 ]"
local result, err = parser.parse(input)
print(result)