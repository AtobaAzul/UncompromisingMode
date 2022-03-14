local env = env
GLOBAL.setfenv(1, GLOBAL)

env.AddPrefabPostInit("batcave", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	if inst.components.childspawner and TUNING.DSTU.ADULTBATILISKS == true then
		inst.components.childspawner.childname = "vampirebat"
	elseif inst.components.childspawner then
		inst.components.childspawner.childname = "bat"
	end
	
end)