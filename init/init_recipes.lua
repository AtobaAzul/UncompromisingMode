--	[ 			Required stuff			]	--
-- The global objects needed for recipe changes
-- Find the default recipes in recipes.lua
	GLOBAL.require("recipe")
	TechTree = GLOBAL.require("techtree")
	TECH = GLOBAL.TECH
	Recipe = GLOBAL.Recipe
	RECIPETABS = GLOBAL.RECIPETABS
	Ingredient = GLOBAL.Ingredient
	AllRecipes = GLOBAL.AllRecipes
	STRINGS = GLOBAL.STRINGS
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
AddRecipe("catcoonhat", {Ingredient("coontail", 4), Ingredient("silk", 4)}, RECIPETABS.DRESS, TECH.SCIENCE_TWO)
GLOBAL.AllRecipes["catcoonhat"].sortkey = GLOBAL.AllRecipes["winterhat"].sortkey + .1

AddRecipe("snowgoggles", {Ingredient("catcoonhat", 1), Ingredient("goggleshat",1), Ingredient("beefalowool",2)}, RECIPETABS.DRESS, TECH.SCIENCE_TWO, nil, nil, nil, nil, nil, "images/inventoryimages/snowgoggles.xml", "snowgoggles.tex" )
GLOBAL.AllRecipes["snowgoggles"].sortkey = GLOBAL.AllRecipes["catcoonhat"].sortkey + .1

AddRecipe("ratpoisonbottle", {Ingredient("red_cap", 1), Ingredient("jammypreserves",1), Ingredient("rocks",1)}, RECIPETABS.FARM, TECH.SCIENCE_ONE, nil, nil, nil, nil, nil, "images/inventoryimages/ratpoisonbottle.xml", "ratpoisonbottle.tex" )
GLOBAL.AllRecipes["ratpoisonbottle"].sortkey = GLOBAL.AllRecipes["fertilizer"].sortkey + .1

--Recipe("sand", {Ingredient("townportaltalisman", 1)}, RECIPETABS.SURVIVAL, TECH.SCIENCE_ONE, nil, nil, nil, 4, nil, "images/inventoryimages/sand.xml", "sand.tex" )

AddRecipe("diseasecurebomb", {Ingredient("cactus_flower", 2), Ingredient("moonrocknugget", 2), Ingredient("spidergland", 3)}, RECIPETABS.SURVIVAL,  TECH.SCIENCE_TWO, nil, nil, nil, nil, nil, "images/inventoryimages/diseasecurebomb.xml", "diseasecurebomb.tex" )
GLOBAL.AllRecipes["diseasecurebomb"].sortkey = GLOBAL.AllRecipes["lifeinjector"].sortkey + .1



--[[
AddRecipe("reviver", {Ingredient("skeletonmeat", 1, "images/inventoryimages/skeletonmeat.xml"), Ingredient("spidergland", 1), Ingredient(GLOBAL.CHARACTER_INGREDIENT.HEALTH, 40)}, RECIPETABS.SURVIVAL,  TECH.NONE)
AddRecipe("bernie_inactive", {Ingredient("berniebox", 1, "images/inventoryimages/berniebox.xml")}, RECIPETABS.SURVIVAL,  TECH.NONE, nil, nil, nil, nil, "pyromaniac")
AddRecipe("moonrockidol", {Ingredient("moonrocknugget", GLOBAL.TUNING.DSTU.RECIPE_MOONROCK_IDOL_MOONSTONE_COST), Ingredient("purplegem", 1)}, RECIPETABS.CELESTIAL, TECH.CELESTIAL_ONE, nil, nil, true)
AddRecipe("minifan", {Ingredient("twigs", 3), Ingredient("petals",4)}, RECIPETABS.SURVIVAL, TECH.NONE)
AddRecipe("goggleshat", {Ingredient("goldnugget", 1), Ingredient("pigskin", 1)}, RECIPETABS.DRESS, TECH.SCIENCE_ONE)
AddRecipe("deserthat", {Ingredient("goggleshat", 1), Ingredient("pigskin", 1)}, RECIPETABS.DRESS, TECH.SCIENCE_TWO)
]]
AddRecipe("ghostlyelixir_fastregen", {Ingredient(GLOBAL.CHARACTER_INGREDIENT.HEALTH, 50), Ingredient("ghostflower", 4)}, CUSTOM_RECIPETABS.ELIXIRBREWING, TECH.NONE, nil, nil, nil, nil, "elixirbrewer")


AllRecipes["reviver"].ingredients = {Ingredient("skeletonmeat", 1, "images/inventoryimages/skeletonmeat.xml"), Ingredient("spidergland", 1)}
--AllRecipes["ghostlyelixir_fastregen"].ingredients = {Ingredient("spidergland", 2), Ingredient("ghostflower", 4)}
--AllRecipes["bernie_inactive"].ingredients = {Ingredient("berniebox", 1, "images/inventoryimages/berniebox.xml")}
AllRecipes["moonrockidol"].ingredients = {Ingredient("moonrocknugget", GLOBAL.TUNING.DSTU.RECIPE_MOONROCK_IDOL_MOONSTONE_COST), Ingredient("purplegem", 1)}
AllRecipes["minifan"].ingredients = {Ingredient("twigs", 3), Ingredient("petals",4)}
AllRecipes["goggleshat"].ingredients = {Ingredient("goldnugget", 4), Ingredient("pigskin",1), Ingredient("houndstooth", 2)}
AllRecipes["deserthat"].ingredients = {Ingredient("goggleshat", 1), Ingredient("pigskin",2)}
AllRecipes["goggleshat"].level = TechTree.Create(TECH.SCIENCE_ONE)
AllRecipes["deserthat"].level = TechTree.Create(TECH.SCIENCE_TWO)

AddRecipe("ice", {Ingredient("snowball_throwable", 4, "images/inventoryimages/snowball_throwable.xml", nil, "snowball_throwable.tex")}, RECIPETABS.FARM, TECH.SCIENCE_ONE)

--GLOBAL.AllRecipes["bernie_inactive"].sortkey = GLOBAL.AllRecipes["healingsalve"].sortkey - .1
GLOBAL.AllRecipes["reviver"].sortkey = GLOBAL.AllRecipes["healingsalve"].sortkey - .2

--AddRecipe("critterlab_real", {Ingredient("moonrocknugget",2),Ingredient("cutgrass", 4),Ingredient("beefalowool",2)}, GLOBAL.RECIPETABS.TOWN, GLOBAL.TECH.LOST, "critterlab_real_placer", nil, nil, nil, nil, "images/inventoryimages/critterlab_real.xml", "critterlab_real.tex" )
AddRecipe("gasmask", {Ingredient("goose_feather", 10),Ingredient("red_cap", 2),Ingredient("pigskin",2)}, GLOBAL.RECIPETABS.DRESS, GLOBAL.TECH.SCIENCE_TWO, nil, nil, nil, nil, nil, "images/inventoryimages/gasmask.xml", "gasmask.tex" )
GLOBAL.AllRecipes["gasmask"].sortkey = GLOBAL.AllRecipes["beehat"].sortkey + .1

AddRecipe("plaguemask", {Ingredient("gasmask", 1, "images/inventoryimages/gasmask.xml"),Ingredient("red_cap", 2),Ingredient("rat_tail",4, "images/inventoryimages/rat_tail.xml")}, GLOBAL.RECIPETABS.DRESS, GLOBAL.TECH.SCIENCE_TWO, nil, nil, nil, nil, nil, "images/inventoryimages/plaguemask.xml", "plaguemask.tex" )
GLOBAL.AllRecipes["plaguemask"].sortkey = GLOBAL.AllRecipes["gasmask"].sortkey + .1

AddRecipe("shroom_skin", {Ingredient("shroom_skin_fragment",4, "images/inventoryimages/shroom_skin_fragment.xml"),Ingredient("froglegs",2)}, GLOBAL.RECIPETABS.REFINE, GLOBAL.TECH.SCIENCE_TWO, nil, nil, nil, nil, nil)--, "images/inventoryimages/plaguemask.xml", "plaguemask.tex" )
GLOBAL.AllRecipes["shroom_skin"].sortkey = GLOBAL.AllRecipes["bearger_fur"].sortkey + .1

AddRecipe("sporepack", {Ingredient("shroom_skin",1),Ingredient("rope", 2),Ingredient("spoiled_food",2)}, GLOBAL.RECIPETABS.SURVIVAL, GLOBAL.TECH.SCIENCE_TWO, nil, nil, nil, nil, nil, "images/inventoryimages/sporepack.xml", "sporepack.tex" )
GLOBAL.AllRecipes["sporepack"].sortkey = GLOBAL.AllRecipes["icepack"].sortkey + .1

AddRecipe("saltpack", {Ingredient("gears", 1),Ingredient("boards", 2),Ingredient("saltrock",8)}, GLOBAL.RECIPETABS.SURVIVAL, GLOBAL.TECH.SCIENCE_TWO, nil, nil, nil, nil, nil, "images/inventoryimages/saltpack.xml", "saltpack.tex" )
GLOBAL.AllRecipes["saltpack"].sortkey = GLOBAL.AllRecipes["sporepack"].sortkey + .1

AddRecipe("air_conditioner", {Ingredient("shroom_skin",2),Ingredient("gears", 2),Ingredient("cutstone",4)}, GLOBAL.RECIPETABS.SCIENCE, GLOBAL.TECH.SCIENCE_TWO, "air_conditioner_placer", nil, nil, nil, nil, "images/inventoryimages/air_conditioner.xml", "air_conditioner.tex" )
GLOBAL.AllRecipes["air_conditioner"].sortkey = GLOBAL.AllRecipes["firesuppressor"].sortkey + .1

AddRecipe("honey_log",   {Ingredient("livinglog", 1), Ingredient("honey", 2)}, CUSTOM_RECIPETABS.NATURE, TECH.NONE, nil, nil, nil, nil, "plantkin", "images/inventoryimages/honey_log.xml", "honey_log.tex" )

AddRecipe("bugzapper",   {Ingredient("torch", 1), Ingredient("transistor", 2), Ingredient("feather_robin", 2)}, GLOBAL.RECIPETABS.WAR, GLOBAL.TECH.SCIENCE_TWO, nil, nil, nil, nil, nil, "images/inventoryimages/bugzapper.xml", "bugzapper.tex" )
GLOBAL.AllRecipes["bugzapper"].sortkey = GLOBAL.AllRecipes["nightstick"].sortkey + .1

AddRecipe("slingshotammo_firecrackers",	{Ingredient("nitre", 1)},	CUSTOM_RECIPETABS.SLINGSHOTAMMO, TECH.SCIENCE_TWO,		{no_deconstruction = true}, nil, nil, 10, "pebblemaker", "images/inventoryimages/slingshotammo_firecrackers.xml", "slingshotammo_firecrackers.tex" )
GLOBAL.AllRecipes["slingshotammo_firecrackers"].sortkey = GLOBAL.AllRecipes["slingshotammo_poop"].sortkey - 0.1

AddRecipe("watermelon_lantern", {Ingredient("watermelon", 1), Ingredient("fireflies", 1)}, RECIPETABS.LIGHT, TECH.SCIENCE_TWO, nil, nil, nil, nil, nil, "images/inventoryimages/watermelon_lantern.xml", "watermelon_lantern.tex" )
GLOBAL.AllRecipes["watermelon_lantern"].sortkey = GLOBAL.AllRecipes["pumpkin_lantern"].sortkey + 0.1

AddRecipe("rat_whip",   {Ingredient("twigs", 3), Ingredient("rope", 1), Ingredient("rat_tail", 3, "images/inventoryimages/rat_tail.xml")}, GLOBAL.RECIPETABS.WAR, GLOBAL.TECH.SCIENCE_TWO, nil, nil, nil, nil, nil, "images/inventoryimages/rat_whip.xml", "rat_whip.tex" )
GLOBAL.AllRecipes["rat_whip"].sortkey = GLOBAL.AllRecipes["whip"].sortkey + .1

Recipe("ancient_amulet_red", 	 {Ingredient("thulecite", 2), 		  Ingredient("nightmarefuel", 3),    Ingredient("redgem", 2)}, GLOBAL.RECIPETABS.ANCIENT, GLOBAL.TECH.ANCIENT_FOUR, nil, nil, true, nil, nil, "images/inventoryimages/ancient_amulet_red.xml", "ancient_amulet_red.tex" )
GLOBAL.AllRecipes["ancient_amulet_red"].sortkey = GLOBAL.AllRecipes["orangeamulet"].sortkey - .1

STRINGS.RECIPE_DESC.SLINGSHOTAMMO_FIRECRACKERS = "For the aspiring young menace."
STRINGS.RECIPE_DESC.WATERMELON_LANTERN = "Juicy illumination."
STRINGS.RECIPE_DESC.CRITTERLAB_REAL = "Cute pals to ruin the mood."
STRINGS.RECIPE_DESC.SAND = "Turn a big rock into smaller rocks."
STRINGS.RECIPE_DESC.SNOWGOGGLES = "Keep your eyes clear and ears extra warm."
STRINGS.RECIPE_DESC.RATPOISONBOTTLE = "Highly addictive to pestilence pests."
STRINGS.RECIPE_DESC.DISEASECUREBOMB = "Effective disease prevention."
STRINGS.RECIPE_DESC.ICE = "Water of the solid kind."
STRINGS.RECIPE_DESC.GASMASK = "Makes everything smell like bird."
STRINGS.RECIPE_DESC.PLAGUEMASK = "You are the cure!"
STRINGS.RECIPE_DESC.SALTPACK = "Spice up the world."
STRINGS.RECIPE_DESC.RATPOISON = "A most deadly feast."
STRINGS.RECIPE_DESC.SHROOM_SKIN = "Stitched skins."
STRINGS.RECIPE_DESC.SPOREPACK = "Unhygenic storage."
STRINGS.RECIPE_DESC.AIR_CONDITIONER = "Condition the air."
STRINGS.RECIPE_DESC.REVIVER = "Dead flesh revived to revive a dead friend."
STRINGS.RECIPE_DESC.HONEY_LOG = "A log a day keeps the sickness at bay."
STRINGS.RECIPE_DESC.BUGZAPPER = "Bite back with electricity!"
STRINGS.RECIPE_DESC.ANCIENT_AMULET_RED = "Recalls your lost soul."
STRINGS.RECIPE_DESC.RAT_WHIP = "A long rat tail on a stick."
