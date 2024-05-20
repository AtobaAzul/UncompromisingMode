local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

env.AddPrefabPostInit("green_mushroom", function(inst)

	inst:RemoveComponent("lootdropper")
	inst:RemoveComponent("workable")
	
    inst:AddComponent("lootdropper")
    inst:AddComponent("workable")	
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
    inst.components.workable:SetOnFinishCallback(function(inst, chopper)
        if inst.components.pickable ~= nil and inst.components.pickable:CanBePicked() then
            inst.components.lootdropper:SpawnLootPrefab("green_cap")
        end
		
		local spore = SpawnPrefab("spore_small")
		spore.Transform:SetPosition(inst.Transform:GetWorldPosition())
		spore.AnimState:PlayAnimation("flight_cycle")	
        inst:Remove()
    end)
    inst.components.workable:SetWorkLeft(1)	
end)

env.AddPrefabPostInit("red_mushroom", function(inst)

	inst:RemoveComponent("lootdropper")
	inst:RemoveComponent("workable")
	
    inst:AddComponent("lootdropper")
    inst:AddComponent("workable")	
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
    inst.components.workable:SetOnFinishCallback(function(inst, chopper)
        if inst.components.pickable ~= nil and inst.components.pickable:CanBePicked() then
            inst.components.lootdropper:SpawnLootPrefab("red_cap")
        end

		local spore = SpawnPrefab("spore_medium")
		spore.Transform:SetPosition(inst.Transform:GetWorldPosition())
		spore.AnimState:PlayAnimation("flight_cycle")
        inst:Remove()
    end)
    inst.components.workable:SetWorkLeft(1)	
end)

env.AddPrefabPostInit("blue_mushroom", function(inst)

	inst:RemoveComponent("lootdropper")
	inst:RemoveComponent("workable")
	
    inst:AddComponent("lootdropper")
    inst:AddComponent("workable")	
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
    inst.components.workable:SetOnFinishCallback(function(inst, chopper)
        if inst.components.pickable ~= nil and inst.components.pickable:CanBePicked() then
            inst.components.lootdropper:SpawnLootPrefab("blue_cap")
        end
		
		local spore = SpawnPrefab("spore_tall")
		spore.Transform:SetPosition(inst.Transform:GetWorldPosition())
		spore.AnimState:PlayAnimation("flight_cycle")
        inst:Remove()
    end)
    inst.components.workable:SetWorkLeft(1)	
end)

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

---------------------------------------------------------
--FEAST AND FAMINE COMPATABILITY--
---------------------------------------------------------
env.AddPrefabPostInit("green_chunk", function(inst)

	inst:AddTag("mushroom_fuel")
	inst:AddTag("green_mushroom_fuel")
	
	if not TheWorld.ismastersim then
		return
	end

end)

env.AddPrefabPostInit("red_chunk", function(inst)

	inst:AddTag("mushroom_fuel")
	inst:AddTag("red_mushroom_fuel")
	
	if not TheWorld.ismastersim then
		return
	end

end)

env.AddPrefabPostInit("blue_chunk", function(inst)

	inst:AddTag("mushroom_fuel")
	inst:AddTag("blue_mushroom_fuel")
	
	if not TheWorld.ismastersim then
		return
	end

end)

env.AddPrefabPostInit("green_chunk_bloom", function(inst)

	inst:AddTag("mushroom_fuel")
	inst:AddTag("green_mushroom_fuel")
	
	if not TheWorld.ismastersim then
		return
	end

end)

env.AddPrefabPostInit("red_chunk_bloom", function(inst)

	inst:AddTag("mushroom_fuel")
	inst:AddTag("red_mushroom_fuel")
	
	if not TheWorld.ismastersim then
		return
	end

end)

env.AddPrefabPostInit("blue_chunk_bloom", function(inst)

	inst:AddTag("mushroom_fuel")
	inst:AddTag("blue_mushroom_fuel")
	
	if not TheWorld.ismastersim then
		return
	end

end)
---------------------------------------------------------
-- --
---------------------------------------------------------

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
--[[
local function testfortransformonload(inst)
	return TheWorld.state.isfullmoon
end
if TUNING.DSTU.MOON_TRANSFORMATIONS then
	env.AddPrefabPostInit("red_mushroom", function(inst)
		if not TheWorld.ismastersim then
			return
		end
		
		inst:AddComponent("uncompromising_transformer")
		inst.components.uncompromising_transformer:SetTransformWorldEvent("isfullmoon", true)
		inst.components.uncompromising_transformer:SetRevertWorldEvent("isfullmoon", false)
		inst.components.uncompromising_transformer:SetOnLoadCheck(testfortransformonload)
		inst.components.uncompromising_transformer.transformPrefab = "mushtree_medium"
		
	end)				
	env.AddPrefabPostInit("green_mushroom", function(inst)
		if not TheWorld.ismastersim then
			return
		end
		
		inst:AddComponent("uncompromising_transformer")
		inst.components.uncompromising_transformer:SetTransformWorldEvent("isfullmoon", true)
		inst.components.uncompromising_transformer:SetRevertWorldEvent("isfullmoon", false)
		inst.components.uncompromising_transformer:SetOnLoadCheck(testfortransformonload)
		inst.components.uncompromising_transformer.transformPrefab = "mushtree_small"
	end)

	env.AddPrefabPostInit("blue_mushroom", function(inst)
		if not TheWorld.ismastersim then
			return
		end
		
		inst:AddComponent("uncompromising_transformer")
		inst.components.uncompromising_transformer:SetTransformWorldEvent("isfullmoon", true)
		inst.components.uncompromising_transformer:SetRevertWorldEvent("isfullmoon", false)
		inst.components.uncompromising_transformer:SetOnLoadCheck(testfortransformonload)
		inst.components.uncompromising_transformer.transformPrefab = "mushtree_tall"
	end)
	env.AddPrefabPostInit("mushtree_medium", function(inst)
		if not TheWorld.ismastersim then
			return
		end
		
		inst:AddComponent("uncompromising_transformer")
	end)

	env.AddPrefabPostInit("mushtree_small", function(inst)
		if not TheWorld.ismastersim then
			return
		end
		
		inst:AddComponent("uncompromising_transformer")
	end)

	env.AddPrefabPostInit("mushtree_tall", function(inst)
		if not TheWorld.ismastersim then
			return
		end
		
		inst:AddComponent("uncompromising_transformer")
	end)
end]]