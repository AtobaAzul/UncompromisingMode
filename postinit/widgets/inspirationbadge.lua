local env = env
GLOBAL.setfenv(1, GLOBAL)

local myself

env.AddClassPostConstruct("widgets/inspirationbadge", function(self, owner, colour)
    local _UpdateState = self.UpdateState
    self.owner = owner
    myself = self

    function self:OnUpdate(dt)
        if TheNet:IsServerPaused() then return end
        
        local shadowDrainMult = 1
        local lunarDrainMult = 1

        --if self.owner:HasTag("player_shadow_aligned") then
            --shadowDrainMult = TUNING.DSTU.WATHGRITHR_SHADOW_INSPIRATION_DRAIN_MULT
            --if self.active == true then self:Hide() end
        --else
        if self.owner:HasTag("player_lunar_aligned") then
            lunarDrainMult = TUNING.DSTU.WATHGRITHR_LUNAR_INSPIRATION_DRAIN_MULT
        end

        local percent = math.max(0, self.percent + dt * TUNING.INSPIRATION_DRAIN_RATE * shadowDrainMult * lunarDrainMult * 0.98 / 100) -- just go a little bit slower than the server so there will be less jumping backwards in the meter
        self:SetPercent(percent)
    end

end)

--AddClientModRPCHandler("InspirationBadgeRPC", "HideBadge", function() myself:Hide() end)
--AddClientModRPCHandler("InspirationBadgeRPC", "ShowBadge", function() myself:Show() end)