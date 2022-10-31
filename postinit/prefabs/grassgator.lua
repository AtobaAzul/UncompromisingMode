local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

env.AddPrefabPostInit("grassgator",function(inst)
    if inst and inst.components.lootdropper ~= nil then
        inst.components.lootdropper:AddChanceLoot("livinglog", 1, "livinglog", 1, "livinglog", 0.5)
    end
end)