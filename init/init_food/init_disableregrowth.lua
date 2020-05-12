local env = env
GLOBAL.setfenv(1, GLOBAL)

env.AddPrefabPostInit("forest", function(inst)
    if not TheWorld.ismastersim then
        return
    end
	
	if inst.components.forestresourcespawner ~= nil then
		inst:RemoveComponent("forestresourcespawner")
	end
	
	if inst.components.regrowthmanager ~= nil then
		inst:RemoveComponent("regrowthmanager")
	end
	
	if inst.components.desolationspawner ~= nil then
		inst:RemoveComponent("desolationspawner")
	end
end)

env.AddPrefabPostInit("cave", function(inst)
    if not TheWorld.ismastersim then
        return
    end
	
	if inst.components.forestresourcespawner ~= nil then
		inst:RemoveComponent("forestresourcespawner")
	end
	
	if inst.components.regrowthmanager ~= nil then
		inst:RemoveComponent("regrowthmanager")
	end
	
	if inst.components.desolationspawner ~= nil then
		inst:RemoveComponent("desolationspawner")
	end
end)