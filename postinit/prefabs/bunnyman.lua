local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

env.AddPrefabPostInit("bunnyman", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	inst:AddTag("bunnyattacker")
	
	inst:RemoveComponent("lootdropper")
	
	inst:AddComponent("lootdropper")
    inst.components.lootdropper:AddChanceLoot("manrabbit_tail", .25)
	inst.components.lootdropper:AddRandomLoot("carrot", 1)
    inst.components.lootdropper:AddRandomLoot("meat", 1)
    inst.components.lootdropper.numrandomloot = 1

end)
