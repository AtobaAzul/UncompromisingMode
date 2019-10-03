------------------------------------------------------------------------------------
-- Value changes of foods
-- Modify them through AddPrefabPostInit with these components inside:
--  inst.components.edible.hungervalue = X
--  inst.components.edible.healthvalue = X
--  inst.components.edible.sanityvalue = X
--  inst.components.perishable:SetPerishTime(ONE_DAY * X)
-- Note: For crocpot food changes, use the require "cooking" module and change cooking.recipes.cookpot
------------------------------------------------------------------------------------

-----------------------------------------------------------------
-- Food attribute changes
-----------------------------------------------------------------
local require = GLOBAL.require
local cooking = require "cooking"
local recipes = cooking.recipes.cookpot

recipes.perogies.perishtime = GLOBAL.TUNING.DSTU.RECIPE_CHANGE_PEROGI_PERISH -- Changed to 10 days, down from 20
recipes.meatballs.hunger = GLOBAL.TUNING.DSTU.RECIPE_CHANGE_MEATBALL_HUNGER -- Changed to 50, down from 62.5


-- prevent cooked eggs birdcage infinite loop
local invalid_foods =
{
    "bird_egg",
    "bird_egg_cooked",
    "rottenegg",
    "monstermeat"
}

local function ShouldAcceptItem(inst, item)
    local seed_name = string.lower(item.prefab .. "_seeds")

    local can_accept = item.components.edible
        and (Prefabs[seed_name] 
        or item.prefab == "seeds"
        or item.components.edible.foodtype == GLOBAL.FOODTYPE.MEAT)

    if table.contains(invalid_foods, item.prefab) then
        can_accept = false
    end

    return can_accept
end

AddPrefabPostInit("birdcage", function (inst)
    inst.components.trader:SetAcceptTest(ShouldAcceptItem)
end)

-- butterfly health reduced (5)
AddPrefabPostInit("butterflywings", function (inst)
    inst.components.edible.healthvalue = GLOBAL.TUNING.DSTU.RECIPE_CHANGE_BUTTERFLY_WING_HEALTH
end)
