local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

local function onblink(staff, pos, caster)
    if caster and staff.components.rechargeable:IsCharged() == true then
        if caster.components.staffsanity then
            caster.components.staffsanity:DoCastingDelta(-TUNING.SANITY_MED)
        elseif caster.components.sanity ~= nil then
            caster.components.sanity:DoDelta(-TUNING.SANITY_MED)
        end
    end
       staff.components.rechargeable:Discharge(1)
end



env.AddPrefabPostInit("orangestaff", function(inst)
    inst:AddComponent("rechargeable")

    inst:RemoveComponent("finiteuses")

    inst.components.blinkstaff.onblinkfn = onblink
end)