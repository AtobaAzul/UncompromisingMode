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
--recipes.meatballs.test = function(cooker, names, tags) return tags.antihistamine and tags.antihistamine >= 3  end,

recipes.perogies.perishtime = GLOBAL.TUNING.DSTU.RECIPE_CHANGE_PEROGI_PERISH -- Changed to 10 days, down from 20
recipes.meatballs.hunger = GLOBAL.TUNING.DSTU.RECIPE_CHANGE_MEATBALL_HUNGER -- Changed to 50, down from 62.5
recipes.butterflymuffin.healthvalue = GLOBAL.TUNING.DSTU.RECIPE_CHANGE_BUTTERMUFFIN_HEALTH -- Changed to 50, down from 62.5
-----------------------------------------------------------------
-- Prevent cooked eggs birdcage infinite loop
-----------------------------------------------------------------


-----------------------------------------------------------------
-- butterfly health reduced
-----------------------------------------------------------------
AddPrefabPostInit("butterflywings", function (inst)
    if inst ~= nil and inst.components.edible ~= nil then
        inst.components.edible.healthvalue = GLOBAL.TUNING.DSTU.FOOD_BUTTERFLY_WING_HEALTH
        inst.components.edible.hungervalue = GLOBAL.TUNING.DSTU.FOOD_BUTTERFLY_WING_HUNGER
        inst.components.edible.perishtime = GLOBAL.TUNING.DSTU.FOOD_BUTTERFLY_WING_HUNGER
    end
end)

AddPrefabPostInit("cactus_meat", function (inst)
    if inst ~= nil and inst.components.edible ~= nil then
        inst.components.edible.healthvalue = -8
    end
end)

AddPrefabPostInit("cactus_meat_cooked", function (inst)
    if inst ~= nil and inst.components.edible ~= nil then
        inst.components.edible.healthvalue = -5
    end
end)

AddPrefabPostInit("green_cap_cooked", function (inst)
    if inst ~= nil and inst.components.edible ~= nil then
        inst.components.edible.healthvalue = -5
    end
end)

local ANTIHISTAMINES = 
{
    "honey",
    "onion",
	"acorn_cooked",
}

local function item_oneatenlow(inst, eater)
	if eater.components.hayfever and eater.components.hayfever.enabled then
		eater.components.hayfever:SetNextSneezeTime(60)			
	end	
end

local function AddAntihistamine(prefab)
    AddPrefabPostInit(prefab, function (inst)
	if inst.components.edible ~= nil then
		inst.components.edible:SetOnEatenFn(item_oneatenlow)
	end
    end)
end

for k, v in pairs(ANTIHISTAMINES) do
	AddAntihistamine(v)
end

--------------------------------------------
--[[
local HISTAMINES = 
{
    "butterflywings",
	"petals",
}

local function item_oneatenhistamine(inst, eater)
	if eater.components.hayfever and eater.components.hayfever.enabled then
		eater.components.hayfever:SetNextSneezeTime(5)			
	end	
end

local function AddHistamine(prefab)
    AddPrefabPostInit(prefab, function (inst)
	
	inst.components.edible:SetOnEatenFn(item_oneatenhistamine)
    end)
end

for k, v in pairs(HISTAMINES) do
	AddHistamine(v)
end
]]
--------------------------------------------

local ANTIHISTAMINES_HIGH = 
{
    "honeynuggets",
	"honeyham",
	"asparagussoup",
	"bonesoup",
	"dragonchilisalad",
	"moqueca",
	"seafoodgumbo",
	
	--"tea",
}

local function item_oneatenhigh(inst, eater)
	if eater.components.hayfever and eater.components.hayfever.enabled then
		eater.components.hayfever:SetNextSneezeTime(400)			
	end	
end

local function AddAntihistamineHigh(prefab)
    AddPrefabPostInit(prefab, function (inst)
	if inst.components.edible ~= nil then
		inst.components.edible:SetOnEatenFn(item_oneatenhigh)
	end
    end)
end

for k, v in pairs(ANTIHISTAMINES_HIGH) do
	AddAntihistamineHigh(v)
end

-------------------------------------------------------

local ANTIHISTAMINES_SUPER = 
{
    "mandrakesoup",
}

local function item_oneatensuper(inst, eater)
	if eater.components.hayfever and eater.components.hayfever.enabled then
		eater.components.hayfever:SetNextSneezeTime(4800)			
	end	
end

local function AddAntihistamineSuper(prefab)
    AddPrefabPostInit(prefab, function (inst)
	if inst.components.edible ~= nil then
		inst.components.edible:SetOnEatenFn(item_oneatensuper)
	end
    end)
end

for k, v in pairs(ANTIHISTAMINES_SUPER) do
	AddAntihistamineSuper(v)
end





-----------------------------------------------------------------
-- Reduce seeds hunger
-----------------------------------------------------------------
AddPrefabPostInit("seeds", function (inst)
    if inst ~= nil and inst.components.edible ~= nil then
        inst.components.edible.hungervalue = GLOBAL.TUNING.DSTU.FOOD_SEEDS_HUNGER
    end
end)
AddPrefabPostInit("seeds_cooked", function (inst)
    if inst ~= nil and inst.components.edible ~= nil then
        inst.components.edible.hungervalue = GLOBAL.TUNING.DSTU.FOOD_SEEDS_HUNGER
    end
end)
