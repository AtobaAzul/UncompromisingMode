if not GLOBAL.TheNet:GetIsServer() then return end

AddComponentPostInit("eater", function(self)
	local _custom_stats_mod_fn = self.custom_stats_mod_fn
	if self.inst:HasTag("player") then
		self.custom_stats_mod_fn = function(inst, health_delta, hunger_delta, sanity_delta, food, feeder)
			if _custom_stats_mod_fn then
				health_delta, hunger_delta, sanity_delta = _custom_stats_mod_fn(inst, health_delta, hunger_delta, sanity_delta, food, feeder)
			end

			if not inst:HasTag("UM_foodregen") and not inst:HasTag("vetcurse") and inst.components.eater ~= nil and inst.components.eater:DoFoodEffects(food) then
				sanity_delta = food.components.edible:GetSanity(self.inst)
			end

			return health_delta, hunger_delta, sanity_delta
		end
	end

    local _DoFoodEffects = self.DoFoodEffects
    function self:DoFoodEffects(food)
        -- Check for favorite food sanity. Otherwise, foods that normally
        -- give negative sanity may not trigger (e.g. Wurt and Durians).
        if food.components.edible:IsFavoriteFood(self.inst) then
            return true
        end
        return _DoFoodEffects(self, food)
    end

	local _PrefersToEat = self.PrefersToEat

	function self:PrefersToEat(food)
		if food.prefab == "winter_food4" and self.inst:HasTag("player") and self.inst:HasTag("ratwhisperer") then
			return self:TestFood(food, self.preferseating)
		else
			if _PrefersToEat ~= nil then --realistically, this should never be nil, but ya never know...
				return _PrefersToEat(self, food)
			end
		end
	end
end)
