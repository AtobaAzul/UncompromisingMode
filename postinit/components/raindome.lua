local env = env
GLOBAL.setfenv(1, GLOBAL)

local TAGS = { "_inventoryitem" }
local NOTAGS = { "INLIMBO" }

env.AddComponentPostInit("raindome", function(self)
    local _OnUpdate = self.OnUpdate
    function self:OnUpdate(dt)
        _OnUpdate(self, dt)

        if self.delay > dt then
            self.delay = self.delay - dt
            return
        end

        local awake = not self.inst:IsAsleep()

        local oldtargets = self.targets
        local x, y, z = self.inst.Transform:GetWorldPosition()

        for i, v in ipairs(TheSim:FindEntities(x, y, z, self.radius, TAGS, NOTAGS)) do
            if oldtargets[v] then
                oldtargets[v] = nil
            else
                if not v:HasTag("tornado_nosucky") then
                    print("adding tag!")
                    v:AddTag("tornado_nosucky")
                end
            end

            self.newtargets[v] = true
            awake = awake or not v:IsAsleep()
        end

        for tgt in pairs(oldtargets) do
            if tgt:HasTag("tornado_nosucky") and tgt:IsValid() then
                tgt:RemoveTag("tornado_nosucky")
            end
            oldtargets[tgt] = nil
        end

        self.targets = self.newtargets
        self.newtargets = oldtargets --just swapping over the now empty table

        self.delay = awake and 1 or 3
    end
end)
