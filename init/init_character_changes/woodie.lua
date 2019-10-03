-- Change woodie idol recipe to require presthatilator
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

-- If goose is over water, increase wetness
AddPrefabPostInit("woodie", function (inst)
    
    local function OnGooseRunningOver(inst, CalculateWerenessDrainRate)

        --Find if goose is running
        if inst._gooserunninglevel > 1 then
            inst._gooserunninglevel = inst._gooserunninglevel - 1
            inst._gooserunning = inst:DoTaskInTime(TUNING.WEREGOOSE_RUN_DRAIN_TIME_DURATION, OnGooseRunningOver, CalculateWerenessDrainRate)
        else
            inst._gooserunning = nil
            inst._gooserunninglevel = nil
        end
        
        --If on water, get wet
        if inst.components.drownable ~= nil and inst.components.drownable:IsOverWater() and IsWereMode("goose") then
            inst.components.moisture:DoDelta(GLOBAL.TUNING.DSTU.GOOSE_WATER_WETNESS_RATE, true)
        end

        inst.components.wereness:SetDrainRate(CalculateWerenessDrainRate(inst, WEREMODES.GOOSE, TheWorld.state.isfullmoon))
    end
end)