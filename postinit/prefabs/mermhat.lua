local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

env.AddPrefabPostInit("mermhat", function(inst)

    inst:RemoveComponent("perishable")

    if not TheWorld.ismastersim then
        return
    end

    inst:AddComponent("fueled")
    inst.components.fueled.fueltype = FUELTYPE.USAGE
    inst.components.fueled:InitializeFuelLevel(TUNING.TOPHAT_PERISHTIME)
    inst.components.fueled:SetDepletedFn(--[[generic_perish]] inst.Remove)
end)
