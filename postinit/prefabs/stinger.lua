local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

env.AddPrefabPostInit("stinger", function(inst)
    if not TheWorld.ismastersim then
        return
    end

    if not TUNING.DSTU.UPDATE_CHECK then
        inst:AddComponent("selfstacker")
    end

    inst:AddComponent("fuel")
end)
