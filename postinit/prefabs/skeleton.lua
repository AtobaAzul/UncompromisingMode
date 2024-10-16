local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

if TUNING.DSTU.LONGPIG then
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

if env.GetModConfigData("maraboss_bottomtext") then
	-- du-du DUN DUN
	env.AddPrefabPostInit("skeleton", function(inst)
		if not TheWorld.ismastersim then
			return
		end
		
		inst:AddComponent("halloweenmoonmutable")
		inst.components.halloweenmoonmutable:SetPrefabMutated("mara_boss1")
	end)
	
	env.AddPrefabPostInit("skeleton_player", function(inst)
		if not TheWorld.ismastersim then
			return
		end
		
		inst:AddComponent("halloweenmoonmutable")
		inst.components.halloweenmoonmutable:SetPrefabMutated("mara_boss1")
	end)

--	env.AddPrefabPostInit("scorched_skeleton", function(inst)
--		if not TheWorld.ismastersim then
--			return
--		end
--		
--		inst:AddComponent("halloweenmoonmutable")
--		inst.components.halloweenmoonmutable:SetPrefabMutated("mara_boss1")
--	end)
end
