------------------------------------------------------------------------------------
-- Value changes of foods
-- Modify them through AddPrefabPostInit with these components inside:
--  inst.components.edible.hungervalue = X
--  inst.components.edible.healthvalue = X
--  inst.components.edible.sanityvalue = X
--  inst.components.perishable:SetPerishTime(ONE_DAY * X)
-- Note: For crocpot food changes, use the require "cooking" module and change cooking.recipes.cookpot
------------------------------------------------------------------------------------

-- butterfly health reduced (5)
AddPrefabPostInit("butterflywings", function (inst)
    inst.components.edible.healthvalue = GLOBAL.TUNING.DSTU.RECIPE_CHANGE_BUTTERFLY_WING_HEALTH
end)

-- meatballs health reduced (50)
local require = GLOBAL.require
local cooking = require "cooking"
cooking.recipes.cookpot.meatballs.hunger = GLOBAL.TUNING.DSTU.RECIPE_CHANGE_MEATBALL_HUNGER