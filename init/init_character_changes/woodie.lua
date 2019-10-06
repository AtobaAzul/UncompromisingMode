-----------------------------------------------------------------
-- Change woodie idol recipe to require presthatilator
-----------------------------------------------------------------
TECH = GLOBAL.TECH
Recipe = GLOBAL.Recipe
RECIPETABS = GLOBAL.RECIPETABS
Ingredient = GLOBAL.Ingredient
AllRecipes = GLOBAL.AllRecipes
STRINGS = GLOBAL.STRINGS
TECH = GLOBAL.TECH
CUSTOM_RECIPETABS = GLOBAL.CUSTOM_RECIPETABS

Recipe("wereitem_goose", {Ingredient("monstermeat", 3), Ingredient("seeds", 3)}, RECIPETABS.MAGIC, TECH.MAGIC_TWO, nil, nil, nil, nil, "werehuman")
Recipe("wereitem_beaver", {Ingredient("monstermeat", 3), Ingredient("log", 2)}, RECIPETABS.MAGIC, TECH.MAGIC_TWO, nil, nil, nil, nil, "werehuman")
Recipe("wereitem_moose", {Ingredient("monstermeat", 3), Ingredient("cutgrass", 2)}, RECIPETABS.MAGIC, TECH.MAGIC_TWO, nil, nil, nil, nil, "werehuman")

-----------------------------------------------------------------
-- If goose is over water, increase wetness
-----------------------------------------------------------------
--TODO: increase wetness properly, and make sure he gets freezing damage
local function OnGooseOverWater(inst)
    if inst.weremode:value() == 3 then
        if inst~=nil and inst.components.drownable ~= nil and inst.components.drownable:IsOverWater() then
            inst.components.moisture:DoDelta(GLOBAL.TUNING.DSTU.GOOSE_WATER_WETNESS_RATE, true)
            print()
        end
    end
    inst:DoTaskInTime(GLOBAL.TUNING.WEREGOOSE_RUN_DRAIN_TIME_DURATION, OnGooseOverWater)
end

AddPrefabPostInit("woodie", function (inst)
    print("AddPrefabPostInit woodie")
    inst:DoTaskInTime(GLOBAL.TUNING.WEREGOOSE_RUN_DRAIN_TIME_DURATION, OnGooseOverWater)
end)