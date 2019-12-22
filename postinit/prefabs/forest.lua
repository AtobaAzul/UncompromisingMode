local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
env.AddPrefabPostInit("forest", function(inst)
    if not TheWorld.ismastersim then
        return
    end
    
    inst:AddComponent("toadrain")
	inst:AddComponent("hayfever_tracker")
	inst:AddComponent("firefallwarning")
	inst:AddComponent("gmoosespawner")
	inst:AddComponent("mock_dragonflyspawner")
end)