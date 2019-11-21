local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

env.AddPrefabPostInit("world", function(inst)
    if inst:HasTag("forest") then
        inst:AddComponent("acidmushrooms")
    end    
end)