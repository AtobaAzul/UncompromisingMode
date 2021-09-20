if not GLOBAL.TheNet:GetIsServer() then return end

AddComponentPostInit("eater", function(self)
    _custom_stats_mod_fn = self.custom_stats_mod_fn

    self.custom_stats_mod_fn = function(inst, health_delta, hunger_delta, sanity_delta, food, feeder)
        if _custom_stats_mod_fn then
            health_delta, hunger_delta, sanity_delta = _custom_stats_mod_fn(inst, health_delta, hunger_delta, sanity_delta, food, feeder)
        end

		if not inst:HasTag("UM_foodregen") and not inst:HasTag("vetcurse") then
			sanity_delta = food.components.edible:GetSanity(inst)
		end
		
        return health_delta, hunger_delta, sanity_delta
    end
end)
