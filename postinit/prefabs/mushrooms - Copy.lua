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
	inst:AddTag("green_mushroom_fuel")
	
	if not TheWorld.ismastersim then
		return
	end

end)

env.AddPrefabPostInit("spore_medium", function(inst)

	inst:AddTag("mushroom_fuel")
	inst:AddTag("red_mushroom_fuel")
	
	if not TheWorld.ismastersim then
		return
	end

end)

env.AddPrefabPostInit("spore_tall", function(inst)

	inst:AddTag("mushroom_fuel")
	inst:AddTag("blue_mushroom_fuel")
	
	if not TheWorld.ismastersim then
		return
	end

end)

local function testfortransformonload(inst)
    return TheWorld.state.isfullmoon
end

env.AddPrefabPostInit("red_mushroom", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	inst:AddComponent("transformer")
    inst.components.transformer:SetTransformWorldEvent("isfullmoon", true)
    inst.components.transformer:SetRevertWorldEvent("isfullmoon", false)
    inst.components.transformer:SetOnLoadCheck(testfortransformonload)
    inst.components.transformer.transformPrefab = "mushtree_medium"
	
end)
env.AddPrefabPostInit("green_mushroom", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	inst:AddComponent("transformer")
    inst.components.transformer:SetTransformWorldEvent("isfullmoon", true)
    inst.components.transformer:SetRevertWorldEvent("isfullmoon", false)
    inst.components.transformer:SetOnLoadCheck(testfortransformonload)
    inst.components.transformer.transformPrefab = "mushtree_small"
end)

env.AddPrefabPostInit("blue_mushroom", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	inst:AddComponent("transformer")
    inst.components.transformer:SetTransformWorldEvent("isfullmoon", true)
    inst.components.transformer:SetRevertWorldEvent("isfullmoon", false)
    inst.components.transformer:SetOnLoadCheck(testfortransformonload)
    inst.components.transformer.transformPrefab = "mushtree_tall"
end)

