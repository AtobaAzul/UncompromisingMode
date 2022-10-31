local env = env
GLOBAL.setfenv(1, GLOBAL)

env.AddClassPostConstruct("widgets/bloodover", function(self, owner)
    local _UpdateState = self.UpdateState
    self.owner = owner

    function self:UpdateState()
        if self.owner.replica ~= nil and self.owner.replica.adrenalineamped or self.owner:HasTag("amped") then
            self:TurnOn()
        else
            return _UpdateState(self)
        end
    end

    local function __UpdateState() self:UpdateState() end

    self.inst:ListenForEvent("adrenalinedelta", __UpdateState, owner)

    self.owner:DoPeriodicTask(FRAMES*5, __UpdateState)
end)