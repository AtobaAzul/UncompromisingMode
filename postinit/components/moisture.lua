local env = env
GLOBAL.setfenv(1, GLOBAL)
local easing = require("easing")

env.AddComponentPostInit("moisture", function(self)
    --[[
    function self:GetMoistureRate()
        if not TheWorld.state.israining then
            return 0
        end

        local waterproofmult =
            (self.inst.components.sheltered ~= nil and
            self.inst.components.sheltered.sheltered and
            self.inst.components.sheltered.waterproofness or 0
            ) +
            (self.inst.components.inventory ~= nil and
            self.inst.components.inventory:GetWaterproofness() or 0
            ) +
            (self.inherentWaterproofness or 0
            ) +
            (
            self.waterproofnessmodifiers:Get() or 0
            )
        if TheWorld:HasTag("monsooning") or TheWorld.net:HasTag("monsooning") then
            if waterproofmult >= 1.8 then
                return 0
            end
            local rate = easing.inSine(TheWorld.state.precipitationrate, self.minMoistureRate, self.maxMoistureRate, 1)
            return rate * (1.8 - waterproofmult)
        else
            if waterproofmult >= 1 then
                return 0
            end
            local rate = easing.inSine(TheWorld.state.precipitationrate, self.minMoistureRate, self.maxMoistureRate, 1)
            return rate * (1 - waterproofmult)
        end
    end]]
    local _DoDelta = self.DoDelta

    function self:DoDelta(num, no_announce, ...)
        if self.inst:HasTag("wetness_affinity") then
            return _DoDelta(self, num * 1.5, no_announce, ...)
        else
            return _DoDelta(self, num, no_announce, ...)
        end
    end

    local _GetDryingRate = self.GetDryingRate

    function self:GetDryingRate(moisturerate, ...)
        if self.inst:HasTag("wetness_affinity") then
            return 0
        else
            return _GetDryingRate(self, moisturerate, ...)
        end
    end
end)
