local pdcsv = pd.Class:new():register("luacsv")

function pdcsv:initialize(sel, atoms)
    self.csv = require("ftcsv")
    self.delimiter = ','
    self.counter = 1
    self.inlets = 1
    self.outlets = 2

    pd.post(tostring(atoms[1]))
    return true
end

-- File to read
function pdcsv:in_1_read(atoms)
    self.filename = tostring(atoms[1])
    self.data, self.headers = self.csv.parse(self.filename, { delimiter=self.delimiter })
    self.n_rows = #self.data
    self.n_columns = #self.headers
    self.counter = 1
    pd.post(string.format("Read and parsed file %s", self.filename))
end

function pdcsv:in_1_delimiter(atoms)
    local delim = tostring(atoms[1])
    
    if delim == 'comma' then
        self.delimiter = ','
    elseif delim == 'semicolon' then
        self.delimiter = ';'
    end
end

-- File stats
function pdcsv:in_1_stats()
    self:outlet(2, "rows", { #self.data })
    self:outlet(2, "columns", { #self.headers })

    local tab = {}
    for i,v in pairs(self.headers) do table.insert(tab, tostring(v)) end

    self:outlet(2, "header", tab)
end

function build_row(t, headers)
    local tab = {}

    for j, col in pairs(headers) do
        local temp = tonumber(t[col])

        if temp then
            table.insert(tab, temp)
        else
            table.insert(tab, t[col])
        end
    end

    return tab
end

function pdcsv:in_1_next()
    if self.counter <= self.n_rows then
        local tab = build_row(self.data[self.counter], self.headers)

        self:outlet(1, "list", tab)
        self.counter = self.counter + 1 
    else
        self:outlet(2, "end", { 1 })
    end
end

function pdcsv:in_1_reset()
    self.counter = 1
end

function pdcsv:in_1_goto(n)
    if n <= self.n_rows then
        local tab = build_row(self.data[n], self.headers)
        self:outlet(1, "list", tab)
        self.counter = n + 1
    else
        pd.post("Index of out range")
    end
end

function pdcsv:in_1_bang()
    for i,v in pairs(self.headers) do
        pd.post("================")
        for j, val in pairs(self.data) do
            pd.post(string.format("%s", val[v]))
        end
    end
end
