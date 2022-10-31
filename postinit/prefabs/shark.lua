local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

env.AddPrefabPostInit("shark", function(inst)
    if not TheWorld.ismastersim then
        return
    end
    inst.components.lootdropper:AddChanceLoot("rockjawleather", 1)
end)