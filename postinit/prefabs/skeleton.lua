local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

if TUNING.DSTU.LONGPIG == true then
	env.AddPrefabPostInit("skeleton", function(inst)
		if not TheWorld.ismastersim then
			return
		end
	
    	inst.components.lootdropper:AddRandomLoot("skeletonmeat", 1)
    	inst.components.lootdropper.numrandomloot = 1
end)

	env.AddPrefabPostInit("skeleton_player", function(inst)
		if not TheWorld.ismastersim then
			return
		end
	
    	inst.components.lootdropper:AddRandomLoot("skeletonmeat", 1)
    	inst.components.lootdropper.numrandomloot = 1
	end)
end