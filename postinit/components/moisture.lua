local env = env
GLOBAL.setfenv(1, GLOBAL)
local easing = require("easing")
------------------------Fire spread is less efficient in winter-----------------------------------------
env.AddComponentPostInit("moisture", function(self)
function self:GetMoistureRate()
    if not TheWorld.state.israining then
        return 0
    end

    local waterproofmult =
        (   self.inst.components.sheltered ~= nil and
            self.inst.components.sheltered.sheltered and
            self.inst.components.sheltered.waterproofness or 0
        ) +
        (   self.inst.components.inventory ~= nil and
            self.inst.components.inventory:GetWaterproofness() or 0
        ) +
        (   self.inherentWaterproofness or 0
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
end
end)