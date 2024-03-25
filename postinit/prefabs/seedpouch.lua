local env = env
GLOBAL.setfenv(1, GLOBAL)



env.AddPrefabPostInit("seedpouch", function(inst)
    if not TheWorld.ismastersim then
        return
    end

    if TUNING.DSTU.UPDATE_CHECK then
        inst.components.container:EnableInfiniteStackSize(true)
    end
end)
