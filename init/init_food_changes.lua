-- butterfly is 5 health
AddPrefabPostInit("butterflywings", function (inst)
    inst.components.edible.healthvalue = GLOBAL.TUNING.HEALING_MEDSMALL - GLOBAL.TUNING.HEALING_SMALL -- (8-3)=5
end)