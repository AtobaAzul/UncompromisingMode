local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

env.AddPrefabPostInit("green_cap", function(inst)

	inst:AddTag("mushroom_fuel")
	inst:AddTag("green_mushroom_fuel")
	
	if not TheWorld.ismastersim then
		return
	end

end)

env.AddPrefabPostInit("red_cap", function(inst)

	inst:AddTag("mushroom_fuel")
	inst:AddTag("red_mushroom_fuel")
	
	if not TheWorld.ismastersim then
		return
	end

end)

env.AddPrefabPostInit("blue_cap", function(inst)

	inst:AddTag("mushroom_fuel")
	inst:AddTag("blue_mushroom_fuel")
	
	if not TheWorld.ismastersim then
		return
	end

end)

env.AddPrefabPostInit("spore_small", function(inst)

	inst:AddTag("mushroom_fuel")
	inst:AddTag("green_spore_fuel")
	
	if not TheWorld.ismastersim then
		return
	end

end)

env.AddPrefabPostInit("spore_medium", function(inst)

	inst:AddTag("mushroom_fuel")
	inst:AddTag("red_spore_fuel")
	
	if not TheWorld.ismastersim then
		return
	end

end)

env.AddPrefabPostInit("spore_tall", function(inst)

	inst:AddTag("mushroom_fuel")
	inst:AddTag("blue_spore_fuel")
	
	if not TheWorld.ismastersim then
		return
	end

end)