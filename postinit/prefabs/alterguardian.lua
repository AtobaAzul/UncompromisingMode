local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

env.AddPrefabPostInit("alterguardian_phase3",function(inst)
    if inst and inst.components.lootdropper ~= nil then
        inst.components.lootdropper:AddChanceLoot("moonstorm_static_item_blueprint", 1)
    end
end)