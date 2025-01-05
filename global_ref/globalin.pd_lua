local d_arr = pd.Class:new():register("globalin")
local array = require("array")

INSPECT = require("inspect")

function d_arr:initialize()
    self.token = self.generate_token()
    self.inlets = 1
    self.outlets = 1

    return true
end

function d_arr:in_1_bang(f)
    if GLOBALVALUE then
        self:outlet(1, "list", GLOBALVALUE)
    end
end


function d_arr:in_1_ltable (atoms)
    local value = atoms[1]
    --self:outlet(1, "list", GLOBALVALUE[value])
    GLOBALVALUE[self.token] = array.deep_copy(GLOBALVALUE[value])
    table.remove(GLOBALVALUE[self.token], 1)
    pd.post(string.format("globalin: %s",INSPECT(GLOBALVALUE)))
end


function d_arr.generate_token()
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