local sender = pd.Class:new():register("senderlua")

function sender:initialize()

    self.shared_data = { value1 = 0.0, value2 = 0.0 }

    self.inlets = 1
    self.outlets = 2

    return true
end

function sender:in_1_bang()
    -- Aggiorna i dati nella tabella
    self.shared_data.value1 = self.shared_data.value1 + 1.0
    self.shared_data.value2 = self.shared_data.value2 + 2.0

    -- Invia la tabella come riferimento
    self:outlet(1, "shared_pointer", self.shared_data)

    --post(string.format("Sender updated values: %f, %f", self.shared_data.value1, self.shared_data.value2))
end