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
CONSTRUCTION_PLANS = GLOBAL.CONSTRUCTION_PLANS
modimport("uncompskins_api.lua")

--Registering all item atlas so we don't have to keep doing it on each craft.
RegisterInventoryItemAtlas("images/inventoryimages/rat_whip.xml", "rat_whip.tex")
RegisterInventoryItemAtlas("images/inventoryimages/snowgoggles.xml", "snowgoggles.tex")
RegisterInventoryItemAtlas("images/inventoryimages/ratpoisonbottle.xml", "ratpoisonbottle.tex")
RegisterInventoryItemAtlas("images/inventoryimages/diseasecurebomb.xml", "diseasecurebomb.tex")
RegisterInventoryItemAtlas("images/inventoryimages/skeletonmeat.xml", "skeletonmeat.tex")
RegisterInventoryItemAtlas("images/inventoryimages/snowball_throwable.xml", "snowball_throwable.tex")
RegisterInventoryItemAtlas("images/inventoryimages/gasmask.xml", "gasmask.tex")
RegisterInventoryItemAtlas("images/inventoryimages/plaguemask.xml", "plaguemask.tex")
RegisterInventoryItemAtlas("images/inventoryimages/shroom_skin_fragment.xml", "shroom_skin_fragment.tex")
RegisterInventoryItemAtlas("images/inventoryimages/sporepack.xml", "sporepack.tex")
RegisterInventoryItemAtlas("images/inventoryimages/air_conditioner.xml", "air_conditioner.tex")
RegisterInventoryItemAtlas("images/inventoryimages/saltpack.xml", "saltpack.tex")
RegisterInventoryItemAtlas("images/inventoryimages/skullchest_child.xml", "skullchest_child.tex")
RegisterInventoryItemAtlas("images/inventoryimages/glass_scales.xml", "glass_scales.tex")
RegisterInventoryItemAtlas("images/inventoryimages/bugzapper.xml", "bugzapper.tex")
RegisterInventoryItemAtlas("images/inventoryimages/turf_hoodedmoss.xml", "turf_hoodedmoss.tex")
RegisterInventoryItemAtlas("images/inventoryimages/slingshotammo_firecrackers.xml", "slingshotammo_firecrackers.tex")
RegisterInventoryItemAtlas("images/inventoryimages/turf_ancienthoodedturf.xml", "turf_ancienthoodedturf.tex")
RegisterInventoryItemAtlas("images/inventoryimages/um_bear_trap_equippable_tooth.xml", "um_bear_trap_equippable_tooth.tex")
RegisterInventoryItemAtlas("images/inventoryimages/um_bear_trap_equippable_gold.xml", "um_bear_trap_equippable_gold.tex")
RegisterInventoryItemAtlas("images/inventoryimages/armor_glassmail.xml", "armor_glassmail.tex")
RegisterInventoryItemAtlas("images/inventoryimages/watermelon_lantern.xml", "watermelon_lantern.tex")
RegisterInventoryItemAtlas("images/inventoryimages/hat_ratmask.xml", "hat_ratmask.tex")
RegisterInventoryItemAtlas("images/inventoryimages/ancient_amulet_red.xml", "ancient_amulet_red.tex")
RegisterInventoryItemAtlas("images/inventoryimages/mutator_trapdoor.xml", "mutator_trapdoor.tex")
RegisterInventoryItemAtlas("images/inventoryimages/moon_tear.xml", "moon_tear.tex")
RegisterInventoryItemAtlas("images/inventoryimages/dormant_rain_horn.xml", "dormant_rain_horn.tex")
RegisterInventoryItemAtlas("images/inventoryimages/driftwoodfishingrod.xml", "driftwoodfishingrod.tex")
RegisterInventoryItemAtlas("images/inventoryimages/rain_horn.xml", "rain_horn.tex")
RegisterInventoryItemAtlas("images/inventoryimages/floral_bandage.xml", "floral_bandage.tex")
RegisterInventoryItemAtlas("images/inventoryimages/rat_tail.xml", "rat_tail.tex")
RegisterInventoryItemAtlas("images/inventoryimages/book_rain.xml", "book_rain.tex")
RegisterInventoryItemAtlas("images/inventoryimages/honey_log.xml", "honey_log.tex")

CONSTRUCTION_PLANS["multiplayer_portal_moonrock_constr"] = {
	Ingredient("moonrocknugget", 20),
	Ingredient("purplemooneye", 1),
	Ingredient("moonglass", 5)
}

--moving most recipe changes to AllRecipes because of beta. Using AddRecipe adds them to the mod recipe filter
--while AllRecipes doesn't. Not sure if there's any issues with that.
if GetModConfigData("longpig") then
	AllRecipes["reviver"].ingredients = {Ingredient("skeletonmeat", 1), Ingredient("spidergland", 1)}
end
if GetModConfigData("wanda_nerf") then
	AllRecipes["pocketwatch_revive"].ingredients = {Ingredient("pocketwatch_parts", 2), Ingredient("livinglog", 2), Ingredient("boneshard", 4)}
end

AllRecipes["moonrockidol"].ingredients = {Ingredient("moonrocknugget", GLOBAL.TUNING.DSTU.RECIPE_MOONROCK_IDOL_MOONSTONE_COST), Ingredient("purplegem", 1)}
AllRecipes["minifan"].ingredients = {Ingredient("twigs", 3), Ingredient("petals",4)}
AllRecipes["seedpouch"].ingredients = {Ingredient("slurtle_shellpieces", 2), Ingredient("waxpaper",1), Ingredient("seeds", 2)}
AllRecipes["catcoonhat"].ingredients = {Ingredient("coontail", 4), Ingredient("silk", 4)}

if not GetModConfigData("beta_compatibility") then
	AllRecipes["goggleshat"].level = TechTree.Create(TECH.SCIENCE_ONE)
	AllRecipes["goggleshat"].ingredients = {Ingredient("goldnugget", 4), Ingredient("pigskin",1), Ingredient("houndstooth", 2)}
	AllRecipes["deserthat"].level = TechTree.Create(TECH.SCIENCE_TWO)
	AllRecipes["deserthat"].ingredients = {Ingredient("goggleshat", 1), Ingredient("pigskin",2)}
AddRecipe("snowgoggles", {Ingredient("catcoonhat", 1), Ingredient("goggleshat",1), Ingredient("beefalowool",2)}, RECIPETABS.DRESS, TECH.SCIENCE_TWO, nil, nil, nil, nil, nil)
GLOBAL.AllRecipes["snowgoggles"].sortkey = GLOBAL.AllRecipes["catcoonhat"].sortkey + .1

AddRecipe("ratpoisonbottle", {Ingredient("red_cap", 1), Ingredient("jammypreserves",1), Ingredient("rocks",1)}, RECIPETABS.FARM, TECH.SCIENCE_ONE, nil, nil, nil, nil, nil)
GLOBAL.AllRecipes["ratpoisonbottle"].sortkey = GLOBAL.AllRecipes["fertilizer"].sortkey + .1

AddRecipe("diseasecurebomb", {Ingredient("cactus_flower", 2), Ingredient("moonrocknugget", 2), Ingredient("spidergland", 3)}, RECIPETABS.SURVIVAL,  TECH.SCIENCE_TWO, nil, nil, nil, nil, nil)
GLOBAL.AllRecipes["diseasecurebomb"].sortkey = GLOBAL.AllRecipes["lifeinjector"].sortkey + .1

AddRecipe("bandage", {Ingredient("papyrus", 1), Ingredient("honey", 2)}, RECIPETABS.SURVIVAL, TECH.SCIENCE_TWO, nil, nil, nil, 1)
GLOBAL.AllRecipes["bandage"].sortkey = GLOBAL.AllRecipes["healingsalve"].sortkey + .1
GLOBAL.AllRecipes["tillweedsalve"].sortkey = GLOBAL.AllRecipes["healingsalve"].sortkey + .1

AddRecipe("ghostlyelixir_fastregen", {Ingredient(GLOBAL.CHARACTER_INGREDIENT.HEALTH, 50), Ingredient("ghostflower", 4)}, CUSTOM_RECIPETABS.ELIXIRBREWING, TECH.NONE, nil, nil, nil, nil, "elixirbrewer")


AddRecipe("ice", {Ingredient("snowball_throwable", 4, "images/inventoryimages/snowball_throwable.xml", nil, "snowball_throwable.tex")}, RECIPETABS.REFINE, TECH.SCIENCE_ONE)

GLOBAL.AllRecipes["reviver"].sortkey = GLOBAL.AllRecipes["healingsalve"].sortkey - .2

AddRecipe("gasmask", {Ingredient("goose_feather", 10),Ingredient("red_cap", 2),Ingredient("pigskin",2)}, GLOBAL.RECIPETABS.DRESS, GLOBAL.TECH.SCIENCE_TWO, nil, nil, nil, nil, nil)
GLOBAL.AllRecipes["gasmask"].sortkey = GLOBAL.AllRecipes["beehat"].sortkey + .1

AddRecipe("plaguemask", {Ingredient("gasmask", 1),Ingredient("red_cap", 2),Ingredient("rat_tail",4)}, GLOBAL.RECIPETABS.DRESS, GLOBAL.TECH.SCIENCE_TWO, nil, nil, nil, nil, nil)
GLOBAL.AllRecipes["plaguemask"].sortkey = GLOBAL.AllRecipes["gasmask"].sortkey + .1
MadeRecipeSkinnable("plaguemask", {
plaguemask_formal = {
	atlas = "images/inventoryimages/plaguemask_formal.xml",
	image = "plaguemask_formal.tex",
},
})

AddRecipe("shroom_skin", {Ingredient("shroom_skin_fragment",4),Ingredient("froglegs",2)}, GLOBAL.RECIPETABS.REFINE, GLOBAL.TECH.SCIENCE_TWO, nil, nil, nil, nil, nil)
GLOBAL.AllRecipes["shroom_skin"].sortkey = GLOBAL.AllRecipes["bearger_fur"].sortkey + .1

AddRecipe("sporepack", {Ingredient("shroom_skin",1),Ingredient("rope", 2),Ingredient("spoiled_food",2)}, GLOBAL.RECIPETABS.SURVIVAL, GLOBAL.TECH.SCIENCE_TWO, nil, nil, nil, nil, nil)
GLOBAL.AllRecipes["sporepack"].sortkey = GLOBAL.AllRecipes["icepack"].sortkey + .1

AddRecipe("saltpack", {Ingredient("gears", 1),Ingredient("boards", 2),Ingredient("saltrock",8)}, GLOBAL.RECIPETABS.SURVIVAL, GLOBAL.TECH.SCIENCE_TWO, nil, nil, nil, nil, nil)
GLOBAL.AllRecipes["saltpack"].sortkey = GLOBAL.AllRecipes["sporepack"].sortkey + .1

AddRecipe("air_conditioner", {Ingredient("shroom_skin",2),Ingredient("gears", 1),Ingredient("cutstone",2)}, GLOBAL.RECIPETABS.SCIENCE, GLOBAL.TECH.SCIENCE_TWO, "air_conditioner_placer", nil, nil, nil, nil)
GLOBAL.AllRecipes["air_conditioner"].sortkey = GLOBAL.AllRecipes["firesuppressor"].sortkey + .1

AddRecipe("skullchest_child", {Ingredient("fossil_piece", 2), Ingredient("nightmarefuel",4), Ingredient("boards",3)}, RECIPETABS.MAGIC, TECH.LOST, "skullchest_child_placer", nil, nil, nil, nil)

AddRecipe("honey_log",   {Ingredient("livinglog", 1), Ingredient("honey", 2)}, CUSTOM_RECIPETABS.NATURE, TECH.NONE, nil, nil, nil, nil, "plantkin")

AddRecipe("bugzapper",   {Ingredient("spear", 1), Ingredient("transistor", 2), Ingredient("feather_canary", 2)}, GLOBAL.RECIPETABS.WAR, GLOBAL.TECH.SCIENCE_TWO, nil, nil, nil, nil, nil)
GLOBAL.AllRecipes["bugzapper"].sortkey = GLOBAL.AllRecipes["nightstick"].sortkey + .1

AddRecipe("slingshotammo_firecrackers",	{Ingredient("nitre", 2), Ingredient("cutgrass", 1)},	CUSTOM_RECIPETABS.SLINGSHOTAMMO, TECH.SCIENCE_TWO,		{no_deconstruction = true}, nil, nil, 10, "pebblemaker")
GLOBAL.AllRecipes["slingshotammo_firecrackers"].sortkey = GLOBAL.AllRecipes["slingshotammo_poop"].sortkey - 0.1

AddRecipe("watermelon_lantern", {Ingredient("watermelon", 1), Ingredient("fireflies", 1)}, RECIPETABS.LIGHT, TECH.SCIENCE_TWO, nil, nil, nil, nil, nil)
GLOBAL.AllRecipes["watermelon_lantern"].sortkey = GLOBAL.AllRecipes["pumpkin_lantern"].sortkey + 0.1

AddRecipe("rat_whip",   {Ingredient("twigs", 3), Ingredient("rope", 1), Ingredient("rat_tail", 3)}, GLOBAL.RECIPETABS.WAR, GLOBAL.TECH.SCIENCE_TWO, nil, nil, nil, nil, nil)
GLOBAL.AllRecipes["rat_whip"].sortkey = GLOBAL.AllRecipes["whip"].sortkey + .1

AddRecipe("ancient_amulet_red", 	 {Ingredient("thulecite", 2), 		  Ingredient("nightmarefuel", 3),    Ingredient("redgem", 2)}, GLOBAL.RECIPETABS.ANCIENT, GLOBAL.TECH.ANCIENT_FOUR, nil, nil, true, nil, nil)
GLOBAL.AllRecipes["ancient_amulet_red"].sortkey = GLOBAL.AllRecipes["orangeamulet"].sortkey - .1
MadeRecipeSkinnable("ancient_amulet_red", {
ancient_amulet_red_demoneye = {
	atlas = "images/inventoryimages/ancient_amulet_red_demoneye.xml",
	image = "ancient_amulet_red_demoneye.tex",
},
})

AddRecipe("turf_hoodedmoss", {Ingredient("twigs", 1), Ingredient("foliage", 1), Ingredient("moonrocknugget", 1)}, RECIPETABS.TURFCRAFTING, TECH.TURFCRAFTING_ONE, nil, nil, true, nil, nil)
AddRecipe("turf_ancienthoodedturf", {Ingredient("turf_hoodedmoss", 1), Ingredient("moonrocknugget", 1), Ingredient("thulecite_pieces", 1)}, RECIPETABS.TURFCRAFTING, TECH.TURFCRAFTING_ONE, nil, nil, true, nil, nil)

AddRecipe("um_bear_trap_equippable_tooth", {Ingredient("cutstone", 2), Ingredient("houndstooth", 3), Ingredient("rope", 1)}, RECIPETABS.WAR, TECH.SCIENCE_TWO, nil, nil, nil, nil, nil)
AddRecipe("um_bear_trap_equippable_gold", {Ingredient("goldnugget", 4), Ingredient("houndstooth", 3), Ingredient("rope", 1)}, RECIPETABS.WAR, TECH.SCIENCE_TWO, nil, nil, nil, nil, nil)

AddRecipe("armor_glassmail", {Ingredient("glass_scales", 1), Ingredient("moonglass_charged", 10)}, RECIPETABS.CELESTIAL, TECH.CELESTIAL_THREE, nil, nil, true, nil, nil)

AddRecipe("mutator_trapdoor", { Ingredient("monstermeat", 2), Ingredient("spidergland", 3), Ingredient("cutgrass", 5)}, CUSTOM_RECIPETABS.SPIDERCRAFT, TECH.SPIDERCRAFT_ONE, nil, nil, nil, nil, "spiderwhisperer")

AddRecipe("book_rain", { Ingredient("papyrus", 2), Ingredient("moon_tear", 1), Ingredient("waterballoon", 4)   	   }, CUSTOM_RECIPETABS.BOOKS, TECH.MAGIC_THREE, nil, nil, nil, nil, "bookbuilder")

AddRecipe("driftwoodfishingrod", 	 {Ingredient("driftwood_log", 3), 		  Ingredient("silk", 3),    Ingredient("rope", 2)}, GLOBAL.RECIPETABS.SURVIVAL, GLOBAL.TECH.SCIENCE_TWO, nil, nil, false, nil, nil)

AddRecipe("hermitshop_rain_horn", {Ingredient("dormant_rain_horn",1), Ingredient("oceanfish_small_9_inv",3), Ingredient("messagebottleempty", 2)}, RECIPETABS.HERMITCRABSHOP, TECH.HERMITCRABSHOP_SEVEN, nil, nil, true, nil, nil, nil, nil, nil,"rain_horn")
GLOBAL.AllRecipes["driftwoodfishingrod"].sortkey = GLOBAL.AllRecipes["fishingrod"].sortkey + .1

AddRecipe("hat_ratmask", {Ingredient("rope",2), Ingredient("rat_tail", 3, "images/inventoryimages/rat_tail.xml"), Ingredient("sewing_kit", 1)}, GLOBAL.RECIPETABS.DRESS, GLOBAL.TECH.SCIENCE_TWO, nil, nil, nil, nil, nil)
GLOBAL.AllRecipes["hat_ratmask"].sortkey = GLOBAL.AllRecipes["plaguemask"].sortkey + .1

if TUNING.DSTU.WOLFGANG_HUNGERMIGHTY then
AddRecipe("mighty_gym",      {Ingredient("boards",     4), Ingredient("cutstone", 2), Ingredient("rope", 3)},  CUSTOM_RECIPETABS.STRONGMAN, TECH.SCIENCE_ONE, "mighty_gym_placer", nil, nil, nil, "stinkman")
AddRecipe("dumbbell",        {Ingredient("rocks",      4), Ingredient("twigs", 1  )},                          CUSTOM_RECIPETABS.STRONGMAN, TECH.NONE, nil, nil, nil, nil, "stinkman")
AddRecipe("dumbbell_golden", {Ingredient("goldnugget", 2), Ingredient("cutstone", 2), Ingredient("twigs", 2)}, CUSTOM_RECIPETABS.STRONGMAN, TECH.SCIENCE_ONE, nil, nil, nil, nil, "stinkman")
AddRecipe("dumbbell_gem",    {Ingredient("purplegem",  1), Ingredient("cutstone", 2), Ingredient("twigs", 2)}, CUSTOM_RECIPETABS.STRONGMAN, TECH.MAGIC_TWO, nil, nil, nil, nil, "stinkman")
end
AddRecipe("floral_bandage", {Ingredient("bandage", 1), Ingredient("cactus_flower", 2)}, GLOBAL.RECIPETABS.SURVIVAL, GLOBAL.TECH.SCIENCE_TWO, nil, nil, false, 1, nil)
GLOBAL.AllRecipes["floral_bandage"].sortkey = GLOBAL.AllRecipes["bandage"].sortkey + .1

--recipes so they can be scappred/deconstructed
AddRecipe("cursed_antler", {Ingredient("boneshard", 8), Ingredient("nightmarefuel", 2)}, nil, GLOBAL.TECH.LOST)
AddRecipe("beargerclaw", {Ingredient("boneshard", 2), Ingredient("furturft", 2)}, nil, GLOBAL.TECH.LOST)
AddRecipe("klaus_amulet", {Ingredient("cutstone", 1), Ingredient("nightmarefuel", 6)}, nil, GLOBAL.TECH.LOST)
AddRecipe("feather_frock", {Ingredient("goose_feather", 6)}, nil, GLOBAL.TECH.LOST)
AddRecipe("gore_horn_hat", {Ingredient("meat", 2), Ingredient("nightmarefuel", 4)}, nil, GLOBAL.TECH.LOST)
AddRecipe("crabclaw", {Ingredient("rocks", 4), Ingredient("cutstone", 1)}, nil, GLOBAL.TECH.LOST)
AddRecipe("slobberlobber", {Ingredient("dragon_scales", 1), Ingredient("meat", 2)}, nil, GLOBAL.TECH.LOST)

else
	--skins broke! help!

	AddRecipe2("snowgoggles", {Ingredient("catcoonhat", 1), Ingredient("goggleshat",1), Ingredient("beefalowool",2)}, TECH.SCIENCE_TWO, nil, {"WINTER", "CLOTHING"})

	AddRecipe2("ratpoisonbottle", {Ingredient("red_cap", 1), Ingredient("jammypreserves",1), Ingredient("rocks",1)}, TECH.SCIENCE_ONE, nil)

	AddRecipe2("diseasecurebomb", {Ingredient("cactus_flower", 2), Ingredient("moonrocknugget", 2), Ingredient("spidergland", 3)}, TECH.SCIENCE_TWO, nil, {"GARDENING", "TOOLS", "RESTORATION"})

	AddRecipe2("ghostlyelixir_fastregen", {Ingredient(GLOBAL.CHARACTER_INGREDIENT.HEALTH, 50), Ingredient("ghostflower", 4)},TECH.MAGIC_TWO, {builder_tag = "elixirbrewer"},{"CHARACTER"})

	AddRecipe2("ice", {Ingredient("snowball_throwable", 4)},TECH.SCIENCE_ONE, nil, {"REFINE"})

	AddRecipe2("gasmask", {Ingredient("goose_feather", 10),Ingredient("red_cap", 2),Ingredient("pigskin",2)}, TECH.SCIENCE_TWO, nil, {"CLOTHING", "RAIN"})

	AddRecipe2("plaguemask", {Ingredient("gasmask", 1),Ingredient("red_cap", 2),Ingredient("rat_tail",4)}, TECH.SCIENCE_TWO, nil, {"CLOTHING", "RAIN"})

	AddRecipe2("shroom_skin", {Ingredient("shroom_skin_fragment",4),Ingredient("froglegs",2)}, TECH.SCIENCE_TWO, nil, {"REFINE"})

	AddRecipe2("sporepack", {Ingredient("shroom_skin",1),Ingredient("rope", 2),Ingredient("spoiled_food",2)}, TECH.SCIENCE_TWO, nil, {"CLOTHING", "CONTAINERS"})

	AddRecipe2("saltpack", {Ingredient("gears", 1),Ingredient("boards", 2),Ingredient("saltrock",8)}, TECH.SCIENCE_TWO, nil, {"TOOLS", "WINTER"})

	AddRecipe2("air_conditioner", {Ingredient("shroom_skin",2),Ingredient("gears", 1),Ingredient("cutstone",2)}, TECH.SCIENCE_TWO, {placer = "air_conditioner_placer"}, {"STRUCTURES"})

	AddRecipe2("skullchest_child", {Ingredient("fossil_piece", 2), Ingredient("nightmarefuel",4), Ingredient("boards",3)}, TECH.LOST, {placer = "skullchest_child_placer"},{"STRUCTURES", "CONTAINERS"})

	AddRecipe2("honey_log",   {Ingredient("livinglog", 1), Ingredient("honey", 2)}, TECH.NONE, {builder_tag = "plantkin"}, {"CHARACTER"})

	AddRecipe2("bugzapper",   {Ingredient("spear", 1), Ingredient("transistor", 2), Ingredient("feather_canary", 2)}, TECH.SCIENCE_TWO, nil, {"WEAPONS"})

	AddRecipe2("slingshotammo_firecrackers",	{Ingredient("nitre", 2), Ingredient("cutgrass", 1)},TECH.SCIENCE_TWO, {deconstruction = true, num_to_give = 10, buider_tag = "pebblemaker"}, {"CHARACTER"})

	AddRecipe2("watermelon_lantern", {Ingredient("watermelon", 1), Ingredient("fireflies", 1)}, TECH.SCIENCE_TWO, nil, {"LIGHT"} )

	AddRecipe2("rat_whip",   {Ingredient("twigs", 3), Ingredient("rope", 1), Ingredient("rat_tail", 3)}, TECH.SCIENCE_TWO, {"WEAPONS"})

	AddRecipe2("ancient_amulet_red", 	 {Ingredient("thulecite", 2), 		  Ingredient("nightmarefuel", 3),    Ingredient("redgem", 2)}, TECH.ANCIENT_FOUR, {nounlock= true})

	AddRecipe2("turf_hoodedmoss", {Ingredient("twigs", 1), Ingredient("foliage", 1), Ingredient("moonrocknugget", 1)}, TECH.TURFCRAFTING_TWO, {num_to_give = 4}, {"DECOR"})
	AddRecipe2("turf_ancienthoodedturf", {Ingredient("turf_hoodedmoss", 1), Ingredient("moonrocknugget", 1), Ingredient("thulecite_pieces", 1)}, TECH.TURFCRAFTING_TWO, {num_to_give = 4}, {"DECOR"})

	AddRecipe2("um_bear_trap_equippable_tooth", {Ingredient("cutstone", 2), Ingredient("houndstooth", 3), Ingredient("rope", 1)}, TECH.SCIENCE_TWO, nil, {"WEAPONS"})
	AddRecipe2("um_bear_trap_equippable_gold", {Ingredient("goldnugget", 4), Ingredient("houndstooth", 3), Ingredient("rope", 1)}, TECH.SCIENCE_TWO, nil, {"WEAPONS"})

	AddRecipe2("armor_glassmail", {Ingredient("glass_scales", 1), Ingredient("moonglass_charged", 10)}, TECH.CELESTIAL_THREE, {nounlock = true})

	AddRecipe2("mutator_trapdoor", { Ingredient("monstermeat", 2), Ingredient("spidergland", 3), Ingredient("cutgrass", 5)}, TECH.SPIDERCRAFT_ONE, {builder_tag = "spiderwhisperer"}, {"CHARACTER"})

	AddRecipe2("book_rain", { Ingredient("papyrus", 2), Ingredient("moon_tear", 1), Ingredient("waterballoon", 4)}, TECH.MAGIC_THREE, {builder_tag = "bookbuilder"}, {"CHARACTER"})

	AddRecipe2("driftwoodfishingrod", 	 {Ingredient("driftwood_log", 3), 		  Ingredient("silk", 3),    Ingredient("rope", 2)}, TECH.SCIENCE_TWO, nil, {"FISHING", "TOOLS"})

	AddRecipe2("hermitshop_rain_horn", {Ingredient("dormant_rain_horn",1), Ingredient("oceanfish_small_9_inv",3), Ingredient("messagebottleempty", 2)}, TECH.HERMITCRABSHOP_SEVEN, {nounlock = true, product = "rain_horn"})

	AddRecipe2("hat_ratmask", {Ingredient("rope",2), Ingredient("rat_tail", 3), Ingredient("sewing_kit", 1)}, TECH.SCIENCE_TWO, nil, {"CLOTHING"})

	AddRecipe2("floral_bandage", {Ingredient("bandage", 1), Ingredient("cactus_flower", 2)}, TECH.SCIENCE_TWO, nil, {"RESTORATION"})

	AddRecipeToFilter("wardrobe", "CONTAINERS")
	
	--deconstruct recipes
	AddDeconstructRecipe("cursed_antler", {Ingredient("boneshard", 8), Ingredient("nightmarefuel", 2)})
	AddDeconstructRecipe("beargerclaw", {Ingredient("boneshard", 2), Ingredient("furtuft", 2)})
	AddDeconstructRecipe("klaus_amulet", {Ingredient("cutstone", 1), Ingredient("nightmarefuel", 6)})
	AddDeconstructRecipe("feather_frock", {Ingredient("goose_feather", 6)})
	AddDeconstructRecipe("gore_horn_hat", {Ingredient("meat", 2), Ingredient("nightmarefuel", 4)})
	AddDeconstructRecipe("crabclaw", {Ingredient("rocks", 4), Ingredient("cutstone", 1)})
	AddDeconstructRecipe("slobberlobber", {Ingredient("dragon_scales", 1), Ingredient("meat", 2)})
end

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
if GetModConfigData("longpig") then
STRINGS.RECIPE_DESC.REVIVER = "Dead flesh revived to revive a dead friend."
end
STRINGS.RECIPE_DESC.HONEY_LOG = "A log a day keeps the sickness at bay."
STRINGS.RECIPE_DESC.BUGZAPPER = "Bite back with electricity!"
STRINGS.RECIPE_DESC.ANCIENT_AMULET_RED = "Recalls your lost soul."
STRINGS.RECIPE_DESC.RAT_WHIP = "Hunger strike!"
STRINGS.RECIPE_DESC.TURF_HOODEDMOSS = "Mossy ground with a hint of lunar magic."
STRINGS.RECIPE_DESC.TURF_ANCIENTHOODEDTURF = "The hooded forest's younger years."
STRINGS.RECIPE_DESC.SKULLCHEST_CHILD = "Interdimensional item storage."
STRINGS.RECIPE_DESC.UM_BEAR_TRAP_EQUIPPABLE_TOOTH = "These jaws need to get a grip!"
STRINGS.RECIPE_DESC.UM_BEAR_TRAP_EQUIPPABLE_GOLD = "My shiny teeth and me!"
STRINGS.RECIPE_DESC.ARMOR_GLASSMAIL = "Surround yourself with broken glass."
STRINGS.RECIPE_DESC.MUTATOR_TRAPDOOR = "They're smart, allegedly."
STRINGS.RECIPE_DESC.DRIFTWOODFISHINGROD = "Go Fancy Fishing. For Fancy Fish."
STRINGS.RECIPE_DESC.BOOK_RAIN = "A catalogue of weather effects."
STRINGS.RECIPE_DESC.RAIN_HORN = "Drown the world."
STRINGS.RECIPE_DESC.HAT_RATMASK = "Sniff out some vermin!"
STRINGS.RECIPE_DESC.FLORAL_BANDAGE = "Sweetened Healing!"
