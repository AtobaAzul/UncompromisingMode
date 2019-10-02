------------------------------------------------------------------------------------
-- Value changes of foods
-- Modify them through AddPrefabPostInit with these components inside:
--  inst.components.edible.hungervalue = X
--  inst.components.edible.healthvalue = X
--  inst.components.edible.sanityvalue = X
--  inst.components.perishable:SetPerishTime(ONE_DAY * X)
-- Note: For crocpot food changes, use the require "cooking" module and change cooking.recipes.cookpot
------------------------------------------------------------------------------------

local ONE_DAY = 480

-- butterfly is 5 health
AddPrefabPostInit("butterflywings", function (inst)
    inst.components.edible.healthvalue = GLOBAL.TUNING.HEALING_MEDSMALL - GLOBAL.TUNING.HEALING_SMALL -- (8-3)=5
end)

-- meatballs is 50 hunger
local require = GLOBAL.require
local cooking = require "cooking"
cooking.recipes.cookpot.meatballs.hunger = TUNING.CALORIES_SMALL*4 -- 12.5 * 4 = 50