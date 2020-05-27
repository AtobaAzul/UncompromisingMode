local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

env.AddPrefabPostInit("frog", function (inst)
    if not TheWorld.ismastersim then
		return
	end

	if not inst.components.eater then
		inst:AddComponent("eater")
		inst.components.eater:SetDiet({ FOODGROUP.OMNI }, { FOODGROUP.OMNI })
		inst.components.eater:SetCanEatHorrible()
		inst.components.eater:SetCanEatRaw()
		inst.components.eater.strongstomach = true -- can eat monster meat!
	end

end)

env.AddPrefabPostInit("toad", function (inst)
    if not TheWorld.ismastersim then
		return
	end

	if not inst.components.eater then
		inst:AddComponent("eater")
		inst.components.eater:SetDiet({ FOODGROUP.OMNI }, { FOODGROUP.OMNI })
		inst.components.eater:SetCanEatHorrible()
		inst.components.eater:SetCanEatRaw()
		inst.components.eater.strongstomach = true -- can eat monster meat!
	end

end)