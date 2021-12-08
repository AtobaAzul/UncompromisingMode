local env = env
GLOBAL.setfenv(1, GLOBAL)

env.AddPrefabPostInit("eyebrellahat", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	if TUNING.DSTU.EYEBRELLAREWORK == true then
		inst.components.fueled:InitializeFuelLevel(TUNING.EYEBRELLA_PERISHTIME*(12/9)) --12 Day Durability
		inst.components.fueled.no_sewing = true
		inst.components.fueled.fueltype = FUELTYPE.EYE
		inst.components.fueled.accepting = true
	else
		if inst.components.insulator ~= nil then
			inst.components.insulator:SetInsulation(TUNING.INSULATION_SMALL)
		end
	end
end)