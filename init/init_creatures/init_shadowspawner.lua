local env = env
GLOBAL.setfenv(1, GLOBAL)

env.AddPrefabPostInit("forest", function(inst)
    if not TheWorld.ismastersim then
        return
    end
	
	if inst.components.shadowcreaturespawner ~= nil then
		inst:RemoveComponent("shadowcreaturespawner")
	end
	
end)

env.AddPrefabPostInit("cave", function(inst)
    if not TheWorld.ismastersim then
        return
    end
	
	if inst.components.shadowcreaturespawner ~= nil then
		inst:RemoveComponent("shadowcreaturespawner")
	end
	
end)

env.AddPrefabPostInit("world", function(inst)
    if not TheWorld.ismastersim then
        return
    end
	
	if inst.components.shadowcreaturespawner ~= nil then
		inst:RemoveComponent("shadowcreaturespawner")
	end
	
end)