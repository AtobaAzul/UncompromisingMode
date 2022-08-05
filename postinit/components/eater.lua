if not GLOBAL.TheNet:GetIsServer() then return end

AddComponentPostInit("eater", function(self)
	local _custom_stats_mod_fn = self.custom_stats_mod_fn
	if self.inst:HasTag("player") then
		self.custom_stats_mod_fn = function(inst, health_delta, hunger_delta, sanity_delta, food, feeder)
			if _custom_stats_mod_fn then
				health_delta, hunger_delta, sanity_delta = _custom_stats_mod_fn(inst, health_delta, hunger_delta, sanity_delta, food, feeder)
			end

			if not inst:HasTag("UM_foodregen") and not inst:HasTag("vetcurse") then
				sanity_delta = food.components.edible:GetSanity(inst)
			end

			return health_delta, hunger_delta, sanity_delta
		end
	end

	function self:PrefersToEat(food)--Hook didn't work, food always came as nil, despite adding nil checks :/
		if food.prefab == "winter_food4" and self.inst:HasTag("player") and not self.inst:HasTag("ratwhisperer") then
			--V2C: fruitcake hack. see how long this code stays untouched - _-"
			return false
		elseif self.nospoiledfood and (food.components.perishable and food.components.perishable:IsSpoiled()) then
			return false
		elseif self.preferseatingtags ~= nil then
			--V2C: now it has the warly hack for only eating prepared foods ;-D
			local preferred = false
			for i, v in ipairs(self.preferseatingtags) do
				if food:HasTag(v) then
					preferred = true
					break
				end
			end
			if not preferred then
				return false
			end
		end
		return self:TestFood(food, self.preferseating)
	end
end)
