local env = env
GLOBAL.setfenv(1, GLOBAL)

if TUNING.DSTU.WATERING_TEMPERATURE then
	env.AddPrefabPostInit("wateringcan", function(inst)
		if not TheWorld.ismastersim then
			return
		end

		inst.components.wateryprotection.temperaturereduction = 0
	end)

	env.AddPrefabPostInit("premiumwateringcan", function(inst)
		if not TheWorld.ismastersim then
			return
		end

		inst.components.wateryprotection.temperaturereduction = 0
	end)
end
