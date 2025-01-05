package.cpath = package.cpath .. ";/home/neum/Documenti/pdlua_externals/userdata_ex/?.so"

local u_data = pd.Class:new():register("datauser")
require("myuserdata")

function u_data:initialize()
    self.inlets = 1
    self.outlets = 1

    return true
end

function u_data:in_1_bang()
    local tab =  { "pippo", 3, 5, 7.5 }
    local userdata = convert_to_userdata(tab)
    pd.post(type(userdata))
    self:outlet(1, "pointer", {userdata} )
    pd.post(string.format("%p", userdata))
end