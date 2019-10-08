-----------------------------------------------------------------
-- Wolfgang scaredy cat bonus is increased significantly
-----------------------------------------------------------------
AddPrefabPostInit("wolfgang", function(inst)
    if inst ~= nil and inst.components.sanity ~= nil then    
        inst.components.sanity.night_drain_mult = GLOBAL.TUNING.DSTU.WOLFGANG_SANITY_MULTIPLIER
        inst.components.sanity.neg_aura_mult = GLOBAL.TUNING.DSTU.WOLFGANG_SANITY_MULTIPLIER
    end
end)

--TODO add a "scared" animation from time to time, as a flavour