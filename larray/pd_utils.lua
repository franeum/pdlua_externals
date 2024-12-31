local DEBUG = true
local utils = {}

if DEBUG then
    utils.lex = dofile('/home/neum/Documents/pdlua_externals/larray/larray.lua')
    utils.Larray = dofile('/home/neum/Documents/pdlua_externals/larray/Ltable.lua')
else
    utils.lex = require('larray')
    utils.Larray = require('Ltable')
end


function utils.larray_to_ltable(sel, atoms, post_callback)
    local ltable, depth = utils.lex.process(sel, atoms, post_callback)
    local larr = utils.Larray(ltable, depth)
    return larr
end


return utils