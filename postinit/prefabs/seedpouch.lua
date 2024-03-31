local env = env
GLOBAL.setfenv(1, GLOBAL)



env.AddPrefabPostInit("seedpouch", function(inst)
    if not TheWorld.ismastersim then
        return
    end

    inst.components.container:EnableInfiniteStackSize(true)
end)
