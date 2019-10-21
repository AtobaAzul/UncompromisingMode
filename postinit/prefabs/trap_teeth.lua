local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

-----------------------------------------------------------------
-- Tooth traps burn (they are literally logs with teeth)
-----------------------------------------------------------------

env.AddPrefabPostInit("trap_teeth", function(inst)
    if not GLOBAL.TheWorld.ismastersim then
        return
    end

    GLOBAL.MakeSmallBurnable(inst)
    GLOBAL.MakeSmallPropagator(inst)
end)