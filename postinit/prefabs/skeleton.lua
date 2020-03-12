local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

env.AddPrefabPostInit("skeleton", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
    inst.components.lootdropper:AddRandomLoot("humanmeat", 1)
    inst.components.lootdropper.numrandomloot = 1
end)

env.AddPrefabPostInit("skeleton_player", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
    inst.components.lootdropper:AddRandomLoot("humanmeat", 1)
    inst.components.lootdropper.numrandomloot = 1
end)