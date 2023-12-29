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

--local ApplyIcecreamBuff = function(inst, eater)
	--if eater.components.debuffable ~= nil and eater.components.debuffable:IsEnabled() and
		--not (eater.components.health ~= nil and eater.components.health:IsDead()) and
		--not eater:HasTag("playerghost") then
		--eater.components.debuffable:AddDebuff("icecreamsanityregenbuff", "icecreamsanityregenbuff")
	--end

	--if inst.OldOnEat ~= nil then
		--return inst.OldOnEat(inst, eater)
	--end
--end


if TUNING.DSTU.MEATBALL then
	local MEATBALLS =
	{
		"meatballs",
		"meatballs_spice_chili",
		"meatballs_spice_garlic",
		"meatballs_spice_salt",
		"meatballs_spice_sugar",
	}

	for k, v in pairs(MEATBALLS) do
		AddPrefabPostInit(v, function(inst)
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
	AddPrefabPostInit(v, function(inst)
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
	AddPrefabPostInit(v, function(inst)
		if inst ~= nil and inst.components.edible ~= nil then
			inst.components.edible.hungervalue = 37.5
			inst.components.edible.sanityvalue = 33
			inst.components.edible.healthvalue = 3
		end
	end)
end


if TUNING.DSTU.ICECREAMBUFF then
	--recipes.icecream.OldOnEat = recipes.icecream.oneatenfn

	local ICECREAM =
	{
		"icecream",
		"icecream_spice_chili",
		"icecream_spice_garlic",
		"icecream_spice_salt",
		"icecream_spice_sugar",
	}

	for k, v in pairs(ICECREAM) do
		AddPrefabPostInit(v, function(inst)
			if inst ~= nil and inst.components.edible ~= nil then
				inst.components.edible.sanityvalue = 100
				--inst.components.edible:SetOnEatenFn(ApplyIcecreamBuff)
			end
		end)
	end
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

if TUNING.DSTU.FARMFOODREDUX then
	local MASHEDPOTATOES =
	{
		"mashedpotatoes",
		"mashedpotatoes_spice_chili",
		"mashedpotatoes_spice_garlic",
		"mashedpotatoes_spice_salt",
		"mashedpotatoes_spice_sugar",
	}

	for k, v in pairs(MASHEDPOTATOES) do
		AddPrefabPostInit(v, function(inst)
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
		AddPrefabPostInit(v, function(inst)
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
		AddPrefabPostInit(v, function(inst)
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
		AddPrefabPostInit(v, function(inst)
			if inst ~= nil and inst.components.edible ~= nil then
				inst.components.edible.healthvalue = 40
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
		AddPrefabPostInit(v, function(inst)
			if inst ~= nil and inst.components.edible ~= nil then
				inst.components.edible.hungervalue = 50
				inst.components.edible.sanityvalue = 33
				inst.components.edible.healthvalue = 15
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
		AddPrefabPostInit(v, function(inst)
			if inst ~= nil and inst.components.edible ~= nil then
				inst.components.edible.hungervalue = 50
				inst.components.edible.healthvalue = 20
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
		AddPrefabPostInit(v, function(inst)
			if inst ~= nil and inst.components.edible ~= nil then
				inst.components.edible.hungervalue = 25
				inst.components.edible.healthvalue = 30
				inst.components.edible.sanityvalue = 20
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
		AddPrefabPostInit(v, function(inst)
			if inst ~= nil and inst.components.edible ~= nil then
				inst.components.edible.hungervalue = 75
				inst.components.edible.healthvalue = 20
				inst.components.edible.sanityvalue = 5
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
		AddPrefabPostInit(v, function(inst)
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
		AddPrefabPostInit(v, function(inst)
			if inst ~= nil and inst.components.edible ~= nil then
				inst.components.edible.hungervalue = 100
				inst.components.edible.healthvalue = 3
				inst.components.edible.sanityvalue = 5
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
AddPrefabPostInit("butterflywings", function(inst)
	inst:AddTag("snapdragons_cant_eat")

	if inst ~= nil and inst.components.edible ~= nil and TUNING.DSTU.BUTTERFLYWINGS_NERF then
		inst.components.edible.healthvalue = GLOBAL.TUNING.DSTU.FOOD_BUTTERFLY_WING_HEALTH
		inst.components.edible.hungervalue = GLOBAL.TUNING.DSTU.FOOD_BUTTERFLY_WING_HUNGER
		inst.components.edible.perishtime = GLOBAL.TUNING.DSTU.FOOD_BUTTERFLY_WING_HUNGER
	end
end)
AddPrefabPostInit("spoiled_food", function(inst)
	if inst ~= nil and inst.components.edible ~= nil then
		inst.components.edible.healthvalue = GLOBAL.TUNING.DSTU.FOOD_SPOILED_FOOD_HEALTH
		inst.components.edible.sanityvalue = GLOBAL.TUNING.DSTU.FOOD_SPOILED_FOOD_SANITY
	end
end)
AddPrefabPostInit("cactus_meat", function(inst)
	if inst ~= nil and inst.components.edible ~= nil then
		inst.components.edible.healthvalue = -8
	end
end)

AddPrefabPostInit("cactus_meat_cooked", function(inst)
	if inst ~= nil and inst.components.edible ~= nil then
		--inst.components.edible.healthvalue = -5
		inst.components.edible.sanityvalue = 5
	end
end)

AddPrefabPostInit("green_cap_cooked", function(inst)
	if inst ~= nil and inst.components.edible ~= nil then
		inst.components.edible.healthvalue = -5
	end
end)

AddPrefabPostInit("cookedmonstermeat", function(inst)
	if inst ~= nil and inst.components.edible ~= nil then
		inst.components.edible.healthvalue = -8
	end
end)

if GetModConfigData("rawcropsnerf") then
	AddPrefabPostInit("potato_cooked", function(inst)
		if inst ~= nil and inst.components.edible ~= nil then
			inst.components.edible.healthvalue = 8
			inst.components.edible.hungervalue = 18.75
		end
	end)

	AddPrefabPostInit("tomato_cooked", function(inst)
		if inst ~= nil and inst.components.edible ~= nil then
			inst.components.edible.healthvalue = 8
		end
	end)

	AddPrefabPostInit("eggplant", function(inst)
		if inst ~= nil and inst.components.edible ~= nil then
			inst.components.edible.hungervalue = 18.75
		end
	end)

	AddPrefabPostInit("eggplant_cooked", function(inst)
		if inst ~= nil and inst.components.edible ~= nil then
			inst.components.edible.hungervalue = 18.75
			inst.components.edible.healthvalue = 12
		end
	end)
end
-----------------------------------------------------------------
-- Reduce seeds hunger
-----------------------------------------------------------------
if TUNING.DSTU.SEEDS then
	AddPrefabPostInit("seeds", function(inst)
		if inst ~= nil and inst.components.edible ~= nil then
			inst.components.edible.hungervalue = GLOBAL.TUNING.DSTU.FOOD_SEEDS_HUNGER
		end
	end)
	AddPrefabPostInit("seeds_cooked", function(inst)
		if inst ~= nil and inst.components.edible ~= nil then
			inst.components.edible.hungervalue = GLOBAL.TUNING.DSTU.FOOD_SEEDS_HUNGER
		end
	end)
end

--sailing rebalanced related foood cahnges
if GetModConfigData("sr_foodrebalance") then
	local faf = GLOBAL.KnownModIndex:IsModEnabled("workshop-1908933602")
	local linguine = {
		"barnaclinguine",
		"barnaclinguine_spice_chili",
		"barnaclinguine_spice_garlic",
		"barnaclinguine_spice_salt",
		"barnaclinguine_spice_sugar"
	}

	if faf then
		for k, v in pairs(linguine) do
			AddPrefabPostInit(
				v,
				function(inst)
					if inst ~= nil and inst.components.edible ~= nil then
						inst.components.edible.hungervalue = 150
						inst.components.edible.healthvalue = 40
						inst.components.edible.sanityvalue = 33
					end
				end
			)
		end
	end

	local pita = {
		"barnaclepita",
		"barnaclepita_spice_chili",
		"barnaclepita_spice_garlic",
		"barnaclepita_spice_salt",
		"barnaclepita_spice_sugar"
	}
	if faf then
		for k, v in pairs(pita) do
			AddPrefabPostInit(
				v,
				function(inst)
					if inst ~= nil and inst.components.edible ~= nil then
						inst.components.edible.hungervalue = 37.5
						inst.components.edible.sanityvalue = 33
						inst.components.edible.healthvalue = 20
					end
				end
			)
		end
	else
		for k, v in pairs(pita) do
			AddPrefabPostInit(
				v,
				function(inst)
					if inst ~= nil and inst.components.edible ~= nil then
						inst.components.edible.hungervalue = 37.5
						inst.components.edible.sanityvalue = 15
						inst.components.edible.healthvalue = 8
					end
				end
			)
		end
	end
	local fishstew = {
		"seafoodgumbo",
		"seafoodgumbo_spice_chili",
		"seafoodgumbo_spice_garlic",
		"seafoodgumbo_spice_salt",
		"seafoodgumbo_spice_sugar"
	}
	for k, v in pairs(fishstew) do
		AddPrefabPostInit(
			v,
			function(inst)
				if inst ~= nil and inst.components.edible ~= nil then
					inst.components.edible.hungervalue = 100
					inst.components.edible.sanityvalue = 5
					inst.components.edible.healthvalue = 5
				end
			end
		)
	end

	local fishsticks = {
		"fishsticks",
		"fishsticks_spice_chili",
		"fishsticks_spice_garlic",
		"fishsticks_spice_salt",
		"fishsticks_spice_sugar"
	}
	for k, v in pairs(fishsticks) do
		AddPrefabPostInit(
			v,
			function(inst)
				if inst ~= nil and inst.components.edible ~= nil then
					inst.components.edible.healthvalue = 20
				end
			end
		)
	end
end
--[[
	do whatever you want
local bunnystew = {
	"bunnystew",
	"bunnystew_spice_chili",
	"bunnystew_spice_garlic",
	"bunnystew_spice_salt",
	"bunnystew_spice_sugar"
}
for k, v in pairs(bunnystew) do
	AddPrefabPostInit(
		v,
		function(inst)
			if inst ~= nil and inst.components.edible ~= nil then
				inst.components.edible.healthvalue = 20
			end
		end
	)
end
]]

--idk where else to put this
local farmplants =
{
	"asparagus",
	"carrot",
	"corn",
	"dragonfruit",
	"durian",
	"eggplant",
	"garlic",
	"onion",
	"pepper",
	"pomegranate",
	"potato",
	"pumpkin",
	"tomato",
	"watermelon",
}

for k, v in ipairs(farmplants) do
	AddPrefabPostInit(v .. "_oversized_waxed", function(inst)
		inst:AddTag("NORATCHECK")
	end)
end

local froglegs = { "froglegs", "froglegs_cooked" }

for k, v in ipairs(froglegs) do
	AddPrefabPostInit(v, function(inst)
		if not GLOBAL.TheWorld.ismastersim then
			return
		end
		if inst.components.tradable == nil then
			inst:AddComponent("tradable")
		end
		inst.components.tradable.goldvalue = TUNING.GOLD_VALUES.MEAT
	end)
end

AddPrefabPostInit("wetgoop", function(inst)
	if not GLOBAL.TheWorld.ismastersim then
		return
	end
	
	if inst.components.perishable ~= nil and inst.components.perishable.onperishreplacement ~= nil then
		if inst.components.perishable.onperishreplacement == "spoiled_food" then
			inst.components.perishable.onperishreplacement = nil
		end
		
		inst.components.perishable:SetOnPerishFn(inst.Remove)
	end
end)