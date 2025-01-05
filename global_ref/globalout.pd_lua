GLOBALVALUE = {}

local d_arr = pd.Class:new():register("globalout")
local array = require("array")

function d_arr:initialize()
    self.token = self.generate_token()
    self.inlets = 1
    self.outlets = 1

    return true
end

function d_arr:in_1_bang(f)
    local t = { 1, 3, 5, 7, 9}
    --GLOBALVALUE = t
    --local token = self.generate_token()
    GLOBALVALUE[self.token] = t

    pd.post(string.format("globalout: %s",INSPECT(GLOBALVALUE)))

    self:outlet(1, "ltable", { self.token })
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