local env = env
GLOBAL.setfenv(1, GLOBAL)
local easing = require("easing")

env.AddComponentPostInit("moisture", function(self)
	local _GetMoistureRate = self.GetMoistureRate

	function self:GetMoistureRate()
		if self.inst:HasTag("under_the_weather") then
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
			if waterproofmult >= 1.5 then
				return 0
			end
			local rate = 0
			if TheWorld.state.precipitationrate ~= nil then
				rate = easing.inSine(TheWorld.state.precipitationrate, self.minMoistureRate, self.maxMoistureRate, 1)
			end
			return (rate + 0.2) * (1.5 - waterproofmult)
		elseif self.inst:HasTag("um_waterfall_moisture_override") then
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

			local waterfall_bonus = self.inst:HasTag("um_waterfall_bonus") and .5 or 0

			if waterproofmult >= (1 + waterfall_bonus) then
				return 0
			end
			local rate = 0
			if TheWorld.state.precipitationrate ~= nil then
				rate = easing.inSine(TheWorld.state.precipitationrate, self.minMoistureRate, self.maxMoistureRate,
					1)
			end
			return (rate + .2 + waterfall_bonus) * ((1 + waterfall_bonus) - waterproofmult)
		else
			return _GetMoistureRate(self)
		end
	end

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
