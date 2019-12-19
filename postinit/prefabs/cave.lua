local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
env.AddPrefabPostInit("cave", function(inst)
    if not TheWorld.ismastersim then
        return
    end
    
    inst:AddComponent("cavedeerclopsspawner")
	--inst:AddComponent("firefallwarning")
end)