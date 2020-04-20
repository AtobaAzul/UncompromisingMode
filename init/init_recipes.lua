--	[ 			Required stuff			]	--
-- The global objects needed for recipe changes
-- Find the default recipes in recipes.lua
	GLOBAL.require("recipe")
	TECH = GLOBAL.TECH
	Recipe = GLOBAL.Recipe
	RECIPETABS = GLOBAL.RECIPETABS
	Ingredient = GLOBAL.Ingredient
	AllRecipes = GLOBAL.AllRecipes
	STRINGS = GLOBAL.STRINGS
	TECH = GLOBAL.TECH
	CUSTOM_RECIPETABS = GLOBAL.CUSTOM_RECIPETABS

--	[ 				Recipes				]	--
	
--	Tool
	
--	Light

--	Survival

--	Food

--	Science

--	Fight

--	Structures
	
--	Refine
	
--	Magic
	
--	Dress
	
--	Ancient
	
-- Celestial

-- Celestial portal upgrade change
-- TODO: Fix it, not working (wait for Wurt upgrade, maybe they change the construction site code to be better for modding)
CONSTRUCTION_PLANS =
{
	["multiplayer_portal_moonrock_constr"] = { Ingredient("purplemooneye", 1), Ingredient("moonrocknugget", 20), Ingredient("moonglass", GLOBAL.TUNING.DSTU.RECIPE_MOONROCK_IDOL_STONE_COST) },
}

AddComponentPostInit("ConstructionSite", function (self)
	function self:GetIngredients()
		return CONSTRUCTION_PLANS[self.inst.prefab] or {}
	end
end)

-- Moonrock idol change
Recipe("moonrockidol", {Ingredient("moonrocknugget", GLOBAL.TUNING.DSTU.RECIPE_MOONROCK_IDOL_MOONSTONE_COST), Ingredient("purplegem", 1)}, RECIPETABS.CELESTIAL, TECH.CELESTIAL_ONE, nil, nil, true)
Recipe("minifan", {Ingredient("twigs", 3), Ingredient("petals",4)}, RECIPETABS.SURVIVAL, TECH.NONE)
Recipe("goggleshat", {Ingredient("goldnugget", 4), Ingredient("pigskin",1), Ingredient("houndstooth", 2)}, RECIPETABS.DRESS, TECH.SCIENCE_ONE)
Recipe("deserthat", {Ingredient("goggleshat", 1), Ingredient("pigskin",2)}, RECIPETABS.DRESS, TECH.SCIENCE_TWO)
Recipe("snowgoggles", {Ingredient("catcoonhat", 1), Ingredient("goggleshat",1), Ingredient("beefalowool",2)}, RECIPETABS.DRESS, TECH.SCIENCE_TWO, nil, nil, nil, nil, nil, "images/inventoryimages/snowgoggles.xml", "snowgoggles.tex" )
Recipe("ratpoisonbottle", {Ingredient("red_cap", 1), Ingredient("jammypreserves",1), Ingredient("rocks",1)}, RECIPETABS.FARM, TECH.SCIENCE_ONE, nil, nil, nil, nil, nil, "images/inventoryimages/ratpoisonbottle.xml", "ratpoisonbottle.tex" )
--Recipe("sand", {Ingredient("townportaltalisman", 1)}, RECIPETABS.SURVIVAL, TECH.SCIENCE_ONE, nil, nil, nil, 4, nil, "images/inventoryimages/sand.xml", "sand.tex" )
Recipe("reviver", {Ingredient("humanmeat_dried", 1), Ingredient("spidergland", 1), Ingredient(GLOBAL.CHARACTER_INGREDIENT.HEALTH, 40)}, RECIPETABS.SURVIVAL,  TECH.NONE)
Recipe("ghostlyelixir_fastregen", {Ingredient(GLOBAL.CHARACTER_INGREDIENT.HEALTH, 50), Ingredient("ghostflower", 4)}, CUSTOM_RECIPETABS.ELIXIRBREWING, TECH.NONE, nil, nil, nil, nil, "elixirbrewer")
Recipe("diseasecurebomb", {Ingredient("cactus_flower", 2), Ingredient("moonrocknugget", 2), Ingredient("spidergland", 3)}, RECIPETABS.SURVIVAL,  TECH.SCIENCE_TWO, nil, nil, nil, nil, nil, "images/inventoryimages/diseasecurebomb.xml", "diseasecurebomb.tex" )
Recipe("ice", {Ingredient("snowball_throwable", 4, "images/inventoryimages/snowball_throwable.xml", nil, "snowball_throwable.tex")}, RECIPETABS.FARM, TECH.SCIENCE_ONE)
GLOBAL.AllRecipes["reviver"].sortkey = GLOBAL.AllRecipes["healingsalve"].sortkey - .1

STRINGS.RECIPE_DESC.SAND = "Turn a big rock into smaller rocks."
STRINGS.RECIPE_DESC.SNOWGOGGLES = "Keep your eyes clear and ears extra warm."
STRINGS.RECIPE_DESC.RATPOISONBOTTLE = "Highly addictive to pestilence pests."
STRINGS.RECIPE_DESC.DISEASECUREBOMB = "Effective disease prevention."
STRINGS.RECIPE_DESC.ICE = "Water of the solid kind."



AddRecipe("gasmask", {Ingredient("goose_feather", 10),Ingredient("green_cap", 2),Ingredient("pigskin",2)}, GLOBAL.RECIPETABS.DRESS, GLOBAL.TECH.SCIENCE_TWO, nil, nil, nil, nil, nil, "images/inventoryimages/gasmask.xml", "gasmask.tex" )