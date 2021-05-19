local env = env
GLOBAL.setfenv(1, GLOBAL)

env.AddPrefabPostInit("batcave", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	if inst.components.childspawner ~= nil and TUNING.DSTU.ADULTBATILISKS == true then
		inst.components.childspawner.childname = "vampirebat"
	end
	
end)