package.cpath = package.cpath .. ";/home/neum/Documenti/pdlua_externals/userdata_ex/?.so"

-- Carica il modulo
require("myuserdata")

-- Crea una tabella con struttura arbitraria
local data = {
    name = "example",
    value = 42,
    extra = { "nested", "data" },
    flag = true,
}

-- Converte la tabella in userdata
local userdata = convert_to_userdata(data)

-- Riconverte il userdata di nuovo in una tabella Lua
local new_table = userdata_to_table(userdata)

-- Controlla i valori nella tabella riconvertita
print(new_table.name)        -- Output: "example"
print(new_table.value)       -- Output: 42
print(new_table.flag)        -- Output: true
print(new_table.extra[1])    -- Output: "nested"
print(new_table.extra[2])    -- Output: "data"
