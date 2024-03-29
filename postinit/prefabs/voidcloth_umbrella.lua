local env = env
GLOBAL.setfenv(1, GLOBAL)


env.AddPrefabPostInit("voidcloth_umbrella", function(inst)
    if not TheWorld.ismastersim then
        return
    end

    inst.components.waterproofer.effectiveness = 1.5
end)
