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
local warly_recipes = cooking.recipes.portablecookpot
--recipes.meatballs.test = function(cooker, names, tags) return tags.antihistamine and tags.antihistamine >= 3  end,

local ApplyIcecreamBuff = function(inst, eater)
            if eater.components.debuffable ~= nil and eater.components.debuffable:IsEnabled() and
                not (eater.components.health ~= nil and eater.components.health:IsDead()) and
                not eater:HasTag("playerghost") then
                eater.components.debuffable:AddDebuff("icecreamsanityregenbuff", "icecreamsanityregenbuff")
            end
			
			if inst.OldOnEat ~= nil then
				return inst.OldOnEat(inst, eater)
			end
        end


if TUNING.DSTU.MEATBALL == true then
	local MEATBALLS = 
	{
		"meatballs",
		"meatballs_spice_chili",
		"meatballs_spice_garlic",
		"meatballs_spice_salt",
		"meatballs_spice_sugar",
	}

	for k, v in pairs(MEATBALLS) do
		AddPrefabPostInit(v, function (inst)
			if inst ~= nil and inst.components.edible ~= nil then
				inst.components.edible.hungervalue = GLOBAL.TUNING.DSTU.RECIPE_CHANGE_MEATBALL_HUNGER
			end
		end)
	end
end


	local FLOWERSALADS = 
	{
		"flowersalad",
		"flowersalad_spice_chili",
		"flowersalad_spice_garlic",
		"flowersalad_spice_salt",
		"flowersalad_spice_sugar",
	}

	for k, v in pairs(FLOWERSALADS) do
		AddPrefabPostInit(v, function (inst)
			if inst ~= nil and inst.components.edible ~= nil then
				inst.components.edible.healthvalue = 60
			end
		end)
	end
	
	local FROGNEWTONS = 
	{
		"frognewton",
		"frognewton_spice_chili",
		"frognewton_spice_garlic",
		"frognewton_spice_salt",
		"frognewton_spice_sugar",
	}

	for k, v in pairs(FROGNEWTONS) do
		AddPrefabPostInit(v, function (inst)
			if inst ~= nil and inst.components.edible ~= nil then
				inst.components.edible.hungervalue = 37.5
				inst.components.edible.sanityvalue = 33
				inst.components.edible.healthvalue = 3
			end
		end)
	end
	
	
if TUNING.DSTU.ICECREAMBUFF == true then
	local ICECREAM = 
	{
		"icecream",
		"icecream_spice_chili",
		"icecream_spice_garlic",
		"icecream_spice_salt",
		"icecream_spice_sugar",
	}

	for k, v in pairs(ICECREAM) do
		AddPrefabPostInit(v, function (inst)
			if inst ~= nil and inst.components.edible ~= nil then
				inst.components.edible.sanityvalue = 0
			end
		end)
	end

	recipes.icecream.OldOnEat = recipes.icecream.oneatenfn
	recipes.icecream.oneatenfn = ApplyIcecreamBuff
end

--[[local BACONEGGS = 
{
	"baconeggs",
	"baconeggs_spice_chili",
	"baconeggs_spice_garlic",
	"baconeggs_spice_salt",
	"baconeggs_spice_sugar",
}

for k, v in pairs(BACONEGGS) do
	AddPrefabPostInit(v, function (inst)
		if inst ~= nil and inst.components.perishable ~= nil then
			inst.components.perishable:SetPerishTime(GLOBAL.TUNING.DSTU.RECIPE_CHANGE_BACONEGG_PERISH)
		end
	end)
end]]

recipes.baconeggs.priority = 9 --No more casino 50/50 baconeggs / monsterlasagna

if TUNING.DSTU.FARMFOODREDUX == true then
	local MASHEDPOTATOES = 
	{
		"mashedpotatoes",
		"mashedpotatoes_spice_chili",
		"mashedpotatoes_spice_garlic",
		"mashedpotatoes_spice_salt",
		"mashedpotatoes_spice_sugar",
	}

	for k, v in pairs(MASHEDPOTATOES) do
		AddPrefabPostInit(v, function (inst)
			if inst ~= nil and inst.components.edible ~= nil then
				inst.components.edible.hungervalue = 75
				inst.components.edible.sanityvalue = 15
			end
		end)
	end
	
	local POTATOTORNADO = 
	{
		"potatotornado",
		"potatotornado_spice_chili",
		"potatotornado_spice_garlic",
		"potatotornado_spice_salt",
		"potatotornado_spice_sugar",
	}

	for k, v in pairs(POTATOTORNADO) do
		AddPrefabPostInit(v, function (inst)
			if inst ~= nil and inst.components.edible ~= nil then
				inst.components.edible.hungervalue = 25
			end
		end)
	end
	
	local SALSA = 
	{
		"salsa",
		"salsa_spice_chili",
		"salsa_spice_garlic",
		"salsa_spice_salt",
		"salsa_spice_sugar",
	}

	for k, v in pairs(SALSA) do
		AddPrefabPostInit(v, function (inst)
			if inst ~= nil and inst.components.edible ~= nil then
				inst.components.edible.sanityvalue = 50
			end
		end)
	end

	local PEPPERPOPPER = 
	{
		"pepperpopper",
		"pepperpopper_spice_chili",
		"pepperpopper_spice_garlic",
		"pepperpopper_spice_salt",
		"pepperpopper_spice_sugar",
	}

	for k, v in pairs(PEPPERPOPPER) do
		AddPrefabPostInit(v, function (inst)
			if inst ~= nil and inst.components.edible ~= nil then
				inst.components.edible.healthvalue  = 40
			end
		end)
	end

	local PUMPKINCOOKIE = 
	{
		"pumpkincookie",
		"pumpkincookie_spice_chili",
		"pumpkincookie_spice_garlic",
		"pumpkincookie_spice_salt",
		"pumpkincookie_spice_sugar",
	}

	for k, v in pairs(PUMPKINCOOKIE) do
		AddPrefabPostInit(v, function (inst)
			if inst ~= nil and inst.components.edible ~= nil then
				inst.components.edible.hungervalue = 50
				inst.components.edible.sanityvalue  = 33
				inst.components.edible.healthvalue  = 15
			end
		end)
	end

	local STUFFEDEGGPLANT = 
	{
		"stuffedeggplant",
		"stuffedeggplant_spice_chili",
		"stuffedeggplant_spice_garlic",
		"stuffedeggplant_spice_salt",
		"stuffedeggplant_spice_sugar",
	}

	for k, v in pairs(STUFFEDEGGPLANT) do
		AddPrefabPostInit(v, function (inst)
			if inst ~= nil and inst.components.edible ~= nil then
				inst.components.edible.hungervalue = 50
				inst.components.edible.healthvalue  = 20
			end
		end)
	end

	local ASPARAGUSSOUP = 
	{
		"asparagussoup",
		"asparagussoup_spice_chili",
		"asparagussoup_spice_garlic",
		"asparagussoup_spice_salt",
		"asparagussoup_spice_sugar",
	}

	for k, v in pairs(ASPARAGUSSOUP) do
		AddPrefabPostInit(v, function (inst)
			if inst ~= nil and inst.components.edible ~= nil then
				inst.components.edible.hungervalue = 25
				inst.components.edible.healthvalue  = 30
				inst.components.edible.sanityvalue  = 20
			end
		end)
	end

	local BUTTERFLYMUFFIN = 
	{
		"butterflymuffin",
		"butterflymuffin_spice_chili",
		"butterflymuffin_spice_garlic",
		"butterflymuffin_spice_salt",
		"butterflymuffin_spice_sugar",
	}

	for k, v in pairs(BUTTERFLYMUFFIN) do
		AddPrefabPostInit(v, function (inst)
			if inst ~= nil and inst.components.edible ~= nil then
				inst.components.edible.hungervalue = 30
				
				if TUNING.DSTU.BUTTMUFFIN == true then
					inst.components.edible.healthvalue = GLOBAL.TUNING.DSTU.RECIPE_CHANGE_BUTTERMUFFIN_HEALTH -- Changed to 50, down from 62.5
				end

				inst.components.edible.sanityvalue  = 10
			end
		end)
	end

	local FISHTACOS = 
	{
		"fishtacos",
		"fishtacos_spice_chili",
		"fishtacos_spice_garlic",
		"fishtacos_spice_salt",
		"fishtacos_spice_sugar",
	}

	for k, v in pairs(FISHTACOS) do
		AddPrefabPostInit(v, function (inst)
			if inst ~= nil and inst.components.edible ~= nil then
				inst.components.edible.hungervalue = 75
				inst.components.edible.healthvalue = 20
				inst.components.edible.sanityvalue  = 5
			end
		end)
	end

	local POTATOSOUFFLE = 
	{
		"potatosouffle",
		"potatosouffle_spice_chili",
		"potatosouffle_spice_garlic",
		"potatosouffle_spice_salt",
		"potatosouffle_spice_sugar",
	}

	for k, v in pairs(POTATOSOUFFLE) do
		AddPrefabPostInit(v, function (inst)
			if inst ~= nil and inst.components.edible ~= nil then
				inst.components.edible.hungervalue = 50
				inst.components.edible.healthvalue = 60
				inst.components.edible.sanityvalue = 5
			end
		end)
	end

	local LEAFYMEATBURGER = 
	{
		"leafymeatburger",
		"leafymeatburger_spice_chili",
		"leafymeatburger_spice_garlic",
		"leafymeatburger_spice_salt",
		"leafymeatburger_spice_sugar",
	}

	for k, v in pairs(LEAFYMEATBURGER) do
		AddPrefabPostInit(v, function (inst)
			if inst ~= nil and inst.components.edible ~= nil then
				inst.components.edible.hungervalue = 100
				inst.components.edible.healthvalue = 3
				inst.components.edible.sanityvalue  = 5
			end
		end)
	end
end
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

AddPrefabPostInit("potato_cooked", function (inst)
    if inst ~= nil and inst.components.edible ~= nil then
        inst.components.edible.healthvalue = 8
		inst.components.edible.hungervalue = 18.75
    end
end)

AddPrefabPostInit("tomato_cooked", function (inst)
    if inst ~= nil and inst.components.edible ~= nil then
        inst.components.edible.healthvalue = 8
    end
end)

AddPrefabPostInit("eggplant", function (inst)
    if inst ~= nil and inst.components.edible ~= nil then
        inst.components.edible.hungervalue = 18.75
    end
end)

AddPrefabPostInit("eggplant_cooked", function (inst)
    if inst ~= nil and inst.components.edible ~= nil then
        inst.components.edible.hungervalue = 18.75
		inst.components.edible.healthvalue = 12
    end
end)

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
