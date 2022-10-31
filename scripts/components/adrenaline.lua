local function onmax(self, max)
    self.inst.counter_max:set(max)
    self.inst.replica.maxadrenaline = max
end

local function oncurrent(self, current)
    self.inst.counter_current:set(current)
    self.inst.replica.currentadrenaline = current
end

local function onisamped(self, isamped)
    if self.classified ~= nil and self.classified.isamped ~= nil then
        self.classified.isamped:set(isamped)
    end
end

local Adrenaline = Class(function(self, inst)
    self.inst = inst
    self.max = 100
    self.current = 25
    self.adrenalinecheck = 0
    self.isamped = false
    self.inst:ListenForEvent("respawn", function(inst) self:OnRespawn() end)
end,
    nil,
    {
        max = onmax,
        current = oncurrent,
        isamped = onisamped
    })

function Adrenaline:OnRespawn()
    local old = self.current
    self.current = 25
    self.inst.replica.adrenaline:SetCurrent(25)

    self.inst:PushEvent("adrenalinedelta", { oldpercent = old / self.max, newpercent = self.current / self.max, overtime = overtime })
end

function Adrenaline:OnSave()
    return { adrenaline = self.current }
end

function Adrenaline:OnLoad(data)
    if data.adrenaline then
        self.current = data.adrenaline
        self:DoDelta(0)
    end
end

function Adrenaline:GetDebugString()
    return string.format("%2.2f / %2.2f", self.current, self.max)
end

function Adrenaline:DoDelta(delta, overtime)
    local old = self.current
    self.current = self.current + delta
    if self.current < 0 then
        self.current = 0
    elseif self.current > self.max then
        self.current = self.max
    end

    if self:GetPercent() < 0.24 then
        if self.inst.components.grogginess ~= nil and not self.inst:HasTag("amped") and not self.inst:HasTag("playerghost") and not self.inst:HasTag("deathamp") then
            self.inst.components.grogginess:AddGrogginess(0.5, 0)
        end
    end

    self.inst:PushEvent("adrenalinedelta", { oldpercent = old / self.max, newpercent = self.current / self.max, overtime = overtime })
end

function Adrenaline:GetPercent()
    return self.current / self.max
end

function Adrenaline:GetCurrent()
    return self.current
end

function Adrenaline:SetPercent(p)
    local old = self.current
    self.current = p * self.max
    self.inst:PushEvent("adrenalinedelta", { oldpercent = old / self.max, newpercent = p })
end

function Adrenaline:SetAmped(amped)
    self.isamped = amped
end

return Adrenaline
