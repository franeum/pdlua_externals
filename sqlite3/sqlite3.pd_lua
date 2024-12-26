local sqlite = pd.Class:new():register("sqlite3")

function sqlite:initialize(sel, atoms)
    self.sql3 = require('lsqlite3complete')
    self.inlets = 1
    self.outlets = 2

    return true
end


function sqlite:in_1_open(atoms)
    self.filename = tostring(atoms[1])
    self.db = self.sql3.open(self.filename)
    pd.post("Opened")
end


function sqlite:in_1_new(atoms)
    self.filename = tostring(atoms[1])
    self.db = self.sql3.open(self.filename)
    pd.post("Opened New DB")
end


function sqlite:in_1_query(atoms)
    local q = nil

    for i,v in pairs(atoms) do 
        if q == nil then
            q = tostring(v)
        else
            q = q .. " " .. tostring(v)
        end 
    end

    for a in self.db:rows(q) do self:outlet(1, "list", a) end
    pd.post(q)
end


function sqlite:finalize()
    self.db:close()
end