local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------


local function onblink(staff, pos, caster)
    if caster and staff.components.rechargeable:IsCharged() then
        if caster.components.staffsanity then
            caster.components.staffsanity:DoCastingDelta(-TUNING.SANITY_MED)
        elseif caster.components.sanity ~= nil then
            caster.components.sanity:DoDelta(-TUNING.SANITY_MED)
        end
        staff.components.rechargeable:Discharge(5)
    else
        staff.components.blinkstaff.blinktask:Cancel()
    end
end

env.AddPrefabPostInit("orangestaff", function(inst)
    inst:AddComponent("rechargeable")

    inst:RemoveComponent("finiteuses")
    if inst ~= nil and inst.components.blinkstaff ~= nil then
        inst.components.blinkstaff.onblinkfn = onblink
    end
end)