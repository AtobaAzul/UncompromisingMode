local env = env
GLOBAL.setfenv(1, GLOBAL)

env.AddPrefabPostInit("crabking", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	inst:AddComponent("vetcurselootdropper")
	inst.components.vetcurselootdropper.loot = "crabclaw"
	inst.components.lootdropper:AddChanceLoot("dormant_rain_horn",1.00)
end)