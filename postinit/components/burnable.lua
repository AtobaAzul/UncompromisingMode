local env = env
GLOBAL.setfenv(1, GLOBAL)
------------------------Fire spread is less efficient in winter-----------------------------------------
env.AddComponentPostInit("burnable", function(self)
    local _OldExtendBurning = self.ExtendBurning
    local _OldStartWildfire = self.StartWildfire

    local function DoneBurning(inst, self)
        local isplant = inst:HasTag("plant") and not (inst.components.diseaseable ~= nil and inst.components.diseaseable:IsDiseased())
        local pos = isplant and inst:GetPosition() or nil

        inst:PushEvent("onburnt")

        if self.onburnt ~= nil then
            self.onburnt(inst)
        end

        if self.inst:IsValid() then
            if inst.components.explosive ~= nil then
                --explosive explode
                inst.components.explosive:OnBurnt()
            end

            if self.extinguishimmediately then
                self:Extinguish()
            end
        end

        if isplant then
            TheWorld:PushEvent("plantkilled", { pos = pos }) --this event is pushed in other places too
        end
    end

    function self:ExtendBurning()
        if TheWorld.state.season == "winter" then
            if self.task ~= nil then
                self.task:Cancel()
            end
            self.task = self.burntime ~= nil and self.inst:DoTaskInTime(self.burntime * (self.controlled_burn and self:CalculateControlledBurnDuration() or 1) * 0.24, DoneBurning, self) or nil
        else
            return _OldExtendBurning(self)
        end
    end

    function self:StartWildfire()
        local x, y, z = self.inst.Transform:GetWorldPosition()
        if #TheSim:FindEntities(x, y, z, 12, { "canopy" }) <= 0 or TheWorld:HasTag("heatwavestart") then
            return _OldStartWildfire(self)
        end
    end
end)
