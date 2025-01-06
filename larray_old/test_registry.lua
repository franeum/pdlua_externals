local registry = require("registry")

-- Salva un oggetto nel registro
local t = {a = 1, b = 2}
local ref = registry.save(t) -- Salva la table e ottieni un riferimento

-- Recupera l'oggetto
local retrieved = registry.retrieve(ref)
print(retrieved.a) -- Output: 1

-- Rimuovi l'oggetto dal registro
registry.remove(ref)