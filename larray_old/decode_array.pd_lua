local d_arr = pd.Class:new():register("decode_array")

function d_arr:initialize(sel, atoms)
    self.reg = require('myregistry')
    self.lex = dofile('/home/neum/Documents/pdlua_externals/larray/larray.lua')
    self.counter = 1
    self.inlets = 1
    self.outlets = 2

    return true
end

function d_arr:in_1_float(f)
    local t = self.reg.retrieve(f)
    pd.post(t.a)
    pd.post(t.b)
end