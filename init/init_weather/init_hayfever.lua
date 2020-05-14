local env = env
GLOBAL.setfenv(1, GLOBAL)

env.AddPrefabPostInit("forest", function(inst)
    if not TheWorld.ismastersim then
        return
    end
	
	inst:AddComponent("hayfever_tracker")
	
end)

env.AddPrefabPostInit("cave", function(inst)
    if not TheWorld.ismastersim then
        return
    end
	
	inst:AddComponent("hayfever_tracker")
	
end)

env.AddPlayerPostInit(function(inst)
if inst:HasTag("scp049") then
inst:AddTag("hasplaguemask")
inst:AddTag("has_gasmask")
end
end)