local env = env
GLOBAL.setfenv(1, GLOBAL)

env.AddPrefabPostInit("heatrock", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	if inst.components.temperature ~= nil then
		inst.components.temperature.inherentinsulation = TUNING.INSULATION_SMALL
		inst.components.temperature.inherentsummerinsulation = TUNING.INSULATION_SMALL
	end
	
end)