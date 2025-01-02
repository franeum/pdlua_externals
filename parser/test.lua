
package.cpath = package.cpath .. ";/home/neum/Documenti/pdlua_externals/parser/?.so"
local parser = require("parser")
local res, err = parser.parse("(3 + 5) * (2 + 10)")
print(res)