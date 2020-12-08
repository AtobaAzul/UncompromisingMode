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

local ApplyIcecreamBuff = function(inst, eater)
            if eater.components.debuffable ~= nil and eater.components.debuffable:IsEnabled() and
                not (eater.components.health ~= nil and eater.components.health:IsDead()) and
                not eater:HasTag("playerghost") then
                eater.components.debuffable:AddDebuff("icecreamsanityregenbuff", "icecreamsanityregenbuff")
            end
        end
recipes.perogies.perishtime = GLOBAL.TUNING.DSTU.RECIPE_CHANGE_PEROGI_PERISH -- Changed to 10 days, down from 20
recipes.meatballs.hunger = GLOBAL.TUNING.DSTU.RECIPE_CHANGE_MEATBALL_HUNGER -- Changed to 50, down from 62.5
recipes.butterflymuffin.healthvalue = GLOBAL.TUNING.DSTU.RECIPE_CHANGE_BUTTERMUFFIN_HEALTH -- Changed to 50, down from 62.5
recipes.icecream.sanity = 0
recipes.icecream.oneatenfn = ApplyIcecreamBuff





------Rare Farmplot Crockpot Foods Change
recipes.mashedpotatoes.hunger = 100

recipes.salsa.hunger = 25
recipes.salsa.sanity = 50

recipes.pepperpopper.health = 60
recipes.pepperpopper.hunger = 50
------

------Uncommon Farmplot Crockpot Foods Change
recipes.pumpkincookie.hunger = 40
recipes.pumpkincookie.sanity = 33
recipes.pumpkincookie.health = 15

recipes.stuffedeggplant.hunger = 45
recipes.stuffedeggplant.health = 15

recipes.asparagussoup.hunger = 25
recipes.asparagussoup.health = 30
recipes.asparagussoup.sanity = 20

recipes.butterflymuffin.health = 30
recipes.butterflymuffin.sanity = 10

--recipes.watermelonicle.health = number
--recipes.watermelonicle.sanity = number
--recipes.watermelonicle.hunger = number
------

------Common Farmplot Crockpot Foods Change
recipes.fishtacos.hunger = 62.5
recipes.fishtacos.health = 15
recipes.fishtacos.sanity = 5
------

recipes.vegstinger.hunger = 30
recipes.vegstinger.health = 10
-----------------------------------------------------------------
-- Prevent cooked eggs birdcage infinite loop
-----------------------------------------------------------------


-----------------------------------------------------------------
-- butterfly health reduced
-----------------------------------------------------------------
AddPrefabPostInit("butterflywings", function (inst)
	inst:AddTag("snapdragons_cant_eat")

    if inst ~= nil and inst.components.edible ~= nil then
        inst.components.edible.healthvalue = GLOBAL.TUNING.DSTU.FOOD_BUTTERFLY_WING_HEALTH
        inst.components.edible.hungervalue = GLOBAL.TUNING.DSTU.FOOD_BUTTERFLY_WING_HUNGER
        inst.components.edible.perishtime = GLOBAL.TUNING.DSTU.FOOD_BUTTERFLY_WING_HUNGER
    end
end)
AddPrefabPostInit("spoiled_food", function (inst)
    if inst ~= nil and inst.components.edible ~= nil then
        inst.components.edible.healthvalue = GLOBAL.TUNING.DSTU.FOOD_SPOILED_FOOD_HEALTH
        inst.components.edible.sanityvalue = GLOBAL.TUNING.DSTU.FOOD_SPOILED_FOOD_SANITY
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

AddPrefabPostInit("cookedmonstermeat", function (inst)
    if inst ~= nil and inst.components.edible ~= nil then
        inst.components.edible.healthvalue = -8
    end
end)

local ANTIHISTAMINES = 
{
    "honey",
    "onion",
	"acorn_cooked",
	"red_cap",
	"red_cap_cooked",
}

local function item_oneatenlow(inst, eater)
	if eater.components.hayfever and eater.components.hayfever.enabled then
		eater.components.hayfever:SetNextSneezeTime(60)			
	end	
end

local function AddAntihistamine(prefab)
    AddPrefabPostInit(prefab, function (inst)
		inst:AddTag("antihistamine")
	
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
	"lobsterbisque",
	"hotchili",
	"vegstinger",
	"pepperpopper",
	"sweettea",
}

local function item_oneatenhigh(inst, eater)
	if eater.components.hayfever and eater.components.hayfever.enabled then
		eater.components.hayfever:SetNextSneezeTime(300)			
	end	
end

local function AddAntihistamineHigh(prefab)
    AddPrefabPostInit(prefab, function (inst)
		inst:AddTag("antihistamine")
	
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
		eater.components.hayfever:SetNextSneezeTime(800)	
	end	
end

local function AddAntihistamineSuper(prefab)
    AddPrefabPostInit(prefab, function (inst)
		inst:AddTag("antihistamine")
	
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
