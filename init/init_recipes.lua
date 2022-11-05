--  [           Required stuff          ]   --
-- The global objects needed for recipe changes
-- Find the default recipes in recipes.lua
local require = GLOBAL.require
require("recipe")

local TechTree = require("techtree")
local TECH = GLOBAL.TECH
local Ingredient = GLOBAL.Ingredient
local AllRecipes = GLOBAL.AllRecipes
local STRINGS = GLOBAL.STRINGS
local CONSTRUCTION_PLANS = GLOBAL.CONSTRUCTION_PLANS
local CRAFTING_FILTERS = GLOBAL.CRAFTING_FILTERS

-- List of Vanilla Recipe Filters
-- "FAVORITES", "CRAFTING_STATION", "SPECIAL_EVENT", "MODS", "CHARACTER", "TOOLS", "LIGHT",
-- "PROTOTYPERS", "REFINE", "WEAPONS", "ARMOUR", "CLOTHING", "RESTORATION", "MAGIC", "DECOR",
-- "STRCUTURES", "CONTAINERS", "COOKING", "GARDENING", "FISHING", "SEAFARING", "RIDING",
-- "WINTER", "SUMMER", "RAIN", "EVERYTHING"

--- Change the sort key of an existing recipe in a particular crafting filter.
--- Note: Recipes are automatically added to the end of a crafting filter tab
--- when the function AddRecipe2 is used. -- KoreanWaffles
-- @recipe_name: (str) the recipe to sort
-- @recipe_reference:(str) the recipe to place the given recipe next to
-- @filter: (str) the crafting filter to sort in
-- @after: (bool) whether the recipe should be sorted after the reference
local function ChangeSortKey(recipe_name, recipe_reference, filter, after)
    local recipes = CRAFTING_FILTERS[filter].recipes
    local recipe_name_index
    local recipe_reference_index

    for i = #recipes, 1, -1 do
        if recipes[i] == recipe_name then
            recipe_name_index = i
        elseif recipes[i] == recipe_reference then
            recipe_reference_index = i + (after and 1 or 0)
        end
        if recipe_name_index and recipe_reference_index then
            if recipe_name_index >= recipe_reference_index then
                table.remove(recipes, recipe_name_index)
                table.insert(recipes, recipe_reference_index, recipe_name)
            else
                table.insert(recipes, recipe_reference_index, recipe_name)
                table.remove(recipes, recipe_name_index)
            end
            break
        end
    end
end

CONSTRUCTION_PLANS["multiplayer_portal_moonrock_constr"] = {
    Ingredient("moonrocknugget", 20),
    Ingredient("purplemooneye", 1),
    Ingredient("moonglass", 5)
}

--moving most recipe changes to AllRecipes because of beta. Using AddRecipe adds them to the mod recipe filter
--while AllRecipes doesn't. Not sure if there's any issues with that.
--skins broke! help!

--Recipe changes
if GetModConfigData("longpig") then
    AllRecipes["reviver"].ingredients = {Ingredient("skeletonmeat", 1), Ingredient("spidergland", 1)}
end

if GetModConfigData("wanda_nerf") then
    AllRecipes["pocketwatch_revive"].ingredients = {Ingredient("pocketwatch_parts", 3), Ingredient("livinglog", 2), Ingredient("reviver", 1)}
end

AllRecipes["moonrockidol"].ingredients = { Ingredient("moonrocknugget", GLOBAL.TUNING.DSTU.RECIPE_MOONROCK_IDOL_MOONSTONE_COST), Ingredient("purplegem", 1)}

AllRecipes["minifan"].ingredients = {Ingredient("twigs", 3), Ingredient("petals", 4)}

AllRecipes["seedpouch"].ingredients = {Ingredient("slurtle_shellpieces", 2), Ingredient("waxpaper", 1), Ingredient("seeds", 2)}

AllRecipes["catcoonhat"].ingredients = {Ingredient("coontail", 4), Ingredient("silk", 4)}

AllRecipes["goggleshat"].ingredients = {Ingredient("goldnugget", 4), Ingredient("pigskin", 1), Ingredient("houndstooth", 2)}

AllRecipes["deserthat"].level = TechTree.Create(TECH.SCIENCE_TWO)

AllRecipes["saddle_race"].ingredients = {Ingredient("livinglog", 2), Ingredient("silk", 4), Ingredient("glommerwings", 1)}

AllRecipes["battlesong_fireresistance"].ingredients = {Ingredient("papyrus", 1), Ingredient("featherpencil", 1), Ingredient("dragon_scales", 1)}

AllRecipes["walterhat"].ingredients = {Ingredient("silk", 4), Ingredient("pinecone", 1)}--????

if GetModConfigData("book_recipes") then
    AllRecipes["book_rain"].ingredients = {Ingredient("papyrus", 2), Ingredient("moon_tear", 1), Ingredient("waterballoon", 4)}
    AllRecipes["book_rain"].level = TechTree.Create(TECH.MAGIC_THREE)
    AllRecipes["book_fish"].ingredients = {Ingredient("papyrus", 2), Ingredient("oceanfishingbobber_oval", 2)}--???????????????
    AllRecipes["book_light"].ingredients = {Ingredient("papyrus", 2), Ingredient("wormlight", 1)}
    AllRecipes["book_light_upgraded"].level = TechTree.Create(TECH.LOST)--??????????????????????????????????????????????
    AllRecipes["bookstation"].ingredients = {Ingredient("livinglog", 4), Ingredient("papyrus", 4), Ingredient("featherpencil", 1)}
end

--magnets and dock 
if GetModConfigData("no4crafts") then --:desolate:
    AllRecipes["dock_kit"].ingredients = {Ingredient("boards", 4), Ingredient("stingers", 2), Ingredient("palmconetree_scale", 4)}
    AllRecipes["boat_magnet_kit"].ingredients = {Ingredient("gears", 1), Ingredient("transistor", 2), Ingredient("um_copper_pipe", 3)}
    AllRecipes["boat_magnet_beacon"].ingredients = {Ingredient("messagebottleempty", 1), Ingredient("transistor", 1), Ingredient("um_copper_pipe", 1)}
end

AllRecipes["fish_box"].testfn = function(pt) return GLOBAL.TheWorld.Map:GetPlatformAtPoint(pt.x, 0, pt.z, -0.5) ~= nil or GLOBAL.TheWorld.Map:GetTileAtPoint(pt.x, 0, pt.z) == GLOBAL.WORLD_TILES.MONKEY_DOCK end

AllRecipes["boat_bumper_shell_kit"].numtogive = 4--8
AllRecipes["boat_bumper_kelp_kit"].numtogive = 4--8
AllRecipes["boat_bumper_shell_kit"].ingredients = {Ingredient("slurtle_shellpieces", 3), Ingredient("rope", 3)}
AllRecipes["boat_bumper_kelp_kit"].ingredients = {Ingredient("kelp", 3), Ingredient("cutgrass", 6)}

if TUNING.DSTU.WOLFGANG_HUNGERMIGHTY then
    AllRecipes["mighty_gym"].ingredients = {Ingredient("boards", 4), Ingredient("cutstone", 2), Ingredient("rope", 3)}
    AllRecipes["dumbbell"].ingredients = {Ingredient("rocks", 4), Ingredient("twigs", 1)}
    AllRecipes["dumbbell_golden"].ingredients = {Ingredient("goldnugget", 2), Ingredient("cutstone", 2), Ingredient("twigs", 2)}
    AllRecipes["dumbbell_gem"].ingredients = {Ingredient("purplegem", 1), Ingredient("cutstone", 2), Ingredient("twigs", 2)}
end

AddRecipe2(
    "ghostlyelixir_fastregen",
    {Ingredient(GLOBAL.CHARACTER_INGREDIENT.HEALTH, 50), Ingredient("ghostflower", 4)},
    TECH.MAGIC_TWO,
    {builder_tag = "elixirbrewer"},
    {"CHARACTER"}
)

--new recipes

AddRecipe2(
    "snowgoggles",
    {Ingredient("catcoonhat", 1), Ingredient("goggleshat", 1), Ingredient("beefalowool", 2)},
    TECH.SCIENCE_TWO,
    nil,
    {"WINTER", "CLOTHING"}
)
ChangeSortKey("snowgoggles", "catcoonhat", "WINTER", true)
ChangeSortKey("snowgoggles", "catcoonhat", "CLOTHING", true)

AddRecipe2(
    "ratpoisonbottle",
    {Ingredient("red_cap", 2), Ingredient("jammypreserves", 1), Ingredient("rocks", 1)},
    TECH.SCIENCE_ONE,
    nil,
    {"TOOLS"}
)
ChangeSortKey("ratpoisonbottle", "trap", "TOOLS", true)

AddRecipe2(
    "diseasecurebomb",
    {Ingredient("cactus_flower", 2), Ingredient("moonrocknugget", 2), Ingredient("spidergland", 3)},
    TECH.SCIENCE_TWO,
    nil,
    {"GARDENING", "TOOLS", "RESTORATION"}
)
ChangeSortKey("diseasecurebomb", "compostwrap", "GARDENING", true)
ChangeSortKey("diseasecurebomb", "premiumwateringcan", "TOOLS", true)
ChangeSortKey("diseasecurebomb", "lifeinjector", "RESTORATION", true)

AddRecipe2("ice_snowball", {Ingredient("snowball_throwable", 4)}, TECH.SCIENCE_ONE, {product = "ice"}, {"REFINE"})
ChangeSortKey("ice_snowball", "beeswax", "REFINE", true)

AddRecipe2(
    "gasmask",
    {Ingredient("goose_feather", 10), Ingredient("red_cap", 2), Ingredient("pigskin", 2)},
    TECH.SCIENCE_TWO,
    nil,
    {"CLOTHING", "RAIN"}
)
ChangeSortKey("gasmask", "beehat", "CLOTHING", true)
ChangeSortKey("gasmask", "beehat", "RAIN", true)

AddRecipe2(
    "plaguemask",
    {Ingredient("gasmask", 1), Ingredient("red_cap", 2), Ingredient("rat_tail", 4)},
    TECH.SCIENCE_TWO,
    nil,
    {"CLOTHING", "RAIN"}
)
ChangeSortKey("plaguemask", "gasmask", "CLOTHING", true)
ChangeSortKey("plaguemask", "gasmask", "RAIN", true)

AddRecipe2(
    "shroom_skin",
    {Ingredient("shroom_skin_fragment", 4), Ingredient("froglegs", 2)},
    TECH.SCIENCE_TWO,
    nil,
    {"REFINE"}
)
ChangeSortKey("shroom_skin", "bearger_fur", "REFINE", true)

AddRecipe2(
    "sporepack",
    {Ingredient("shroom_skin", 1), Ingredient("rope", 2), Ingredient("spoiled_food", 2)},
    TECH.SCIENCE_TWO,
    nil,
    {"CLOTHING", "CONTAINERS"}
)
ChangeSortKey("sporepack", "icepack", "CLOTHING", true)
ChangeSortKey("sporepack", "icepack", "CONTAINERS", true)

AddRecipe2(
    "saltpack",
    {Ingredient("gears", 1), Ingredient("boards", 2), Ingredient("saltrock", 8)},
    TECH.SCIENCE_TWO,
    nil,
    {"TOOLS", "WINTER"}
)
ChangeSortKey("saltpack", "brush", "TOOLS", true)
ChangeSortKey("saltpack", "beargervest", "WINTER", true)

AddRecipe2(
    "air_conditioner",
    {Ingredient("shroom_skin", 2), Ingredient("gears", 1), Ingredient("cutstone", 2)},
    TECH.SCIENCE_TWO,
    {placer = "air_conditioner_placer"},
    {"STRUCTURES"}
)
ChangeSortKey("air_conditioner", "firesuppressor", "STRUCTURES", true)

AddRecipe2(
    "skullchest_child",
    {Ingredient("fossil_piece", 2), Ingredient("nightmarefuel", 4), Ingredient("boards", 3)},
    TECH.LOST,
    {placer = "skullchest_child_placer"},
    {"STRUCTURES", "CONTAINERS"}
)
ChangeSortKey("skullchest_child", "dragonflychest", "STRUCTURES", true)
ChangeSortKey("skullchest_child", "dragonflychest", "CONTAINERS", true)

AddRecipe2(
    "honey_log",
    {Ingredient("livinglog", 1), Ingredient("honey", 2)},
    TECH.NONE,
    {builder_tag = "plantkin"},
    {"CHARACTER"}
)
ChangeSortKey("honey_log", "livinglog", "CHARACTER", true)

AddRecipe2(
    "bugzapper",
    {Ingredient("spear", 1), Ingredient("transistor", 2), Ingredient("feather_canary", 2)},
    TECH.SCIENCE_TWO,
    nil,
    {"WEAPONS"}
)
ChangeSortKey("bugzapper", "nightstick", "WEAPONS", true)

AddRecipe2(
    "watermelon_lantern",
    {Ingredient("watermelon", 1), Ingredient("fireflies", 1)},
    TECH.SCIENCE_TWO,
    nil,
    {"LIGHT"}
)
ChangeSortKey("watermelon_lantern", "pumpkin_lantern", "LIGHT", true)

AddRecipe2(
    "rat_whip",
    {Ingredient("twigs", 3), Ingredient("rope", 1), Ingredient("rat_tail", 3)},
    TECH.SCIENCE_TWO,
    nil,
    {"WEAPONS"}
)
ChangeSortKey("rat_whip", "whip", "WEAPONS", true)

AddRecipe2(
    "ancient_amulet_red",
    {Ingredient("thulecite", 2), Ingredient("nightmarefuel", 3), Ingredient("redgem", 2)},
    TECH.ANCIENT_FOUR,
    {nounlock = true},
    {"CRAFTING_STATION"}
)
ChangeSortKey("ancient_amulet_red", "orangeamulet", "CRAFTING_STATION", true)

AddRecipe2(
    "turf_hoodedmoss",
    {Ingredient("twigs", 1), Ingredient("greenfoliage", 4)},
    TECH.TURFCRAFTING_TWO,
    {numtogive = 4},
    {"DECOR"}
)
ChangeSortKey("turf_hoodedmoss", "turf_deciduous", "DECOR", true)

AddRecipe2(
    "turf_ancienthoodedturf",
    {Ingredient("turf_hoodedmoss", 2), Ingredient("moonrocknugget", 1)},
    TECH.TURFCRAFTING_TWO,
    {numtogive = 4},
    {"DECOR"}
)
ChangeSortKey("turf_ancienthoodedturf", "turf_hoodedmoss", "DECOR", true)

AddRecipe2(
    "um_bear_trap_equippable_tooth",
    {Ingredient("cutstone", 2), Ingredient("houndstooth", 3), Ingredient("rope", 1)},
    TECH.SCIENCE_TWO,
    {nil},
    {"WEAPONS"}
)
ChangeSortKey("um_bear_trap_equippable_tooth", "trap_teeth", "WEAPONS", true)

AddRecipe2(
    "um_bear_trap_equippable_gold",
    {Ingredient("goldnugget", 4), Ingredient("houndstooth", 3), Ingredient("rope", 1)},
    TECH.SCIENCE_TWO,
    {nil},
    {"WEAPONS"}
)
ChangeSortKey("um_bear_trap_equippable_gold", "um_bear_trap_equippable_tooth", "WEAPONS", true)

AddRecipe2(
    "armor_glassmail",
    {Ingredient("glass_scales", 1), Ingredient("moonglass_charged", 10)},
    TECH.CELESTIAL_THREE,
    {nounlock = true},
    {"CRAFTING_STATION"}
)
ChangeSortKey("armor_glassmail", "glasscutter", "CRAFTING_STATION", true)

AddRecipe2(
    "mutator_trapdoor",
    {Ingredient("monstermeat", 2), Ingredient("spidergland", 3), Ingredient("cutgrass", 5)},
    TECH.SPIDERCRAFT_ONE,
    {builder_tag = "spiderwhisperer"},
    {"CHARACTER"}
)
ChangeSortKey("mutator_trapdoor", "mutator_warrior", "CHARACTER", true)

AddRecipe2(
    "driftwoodfishingrod",
    {Ingredient("driftwood_log", 3), Ingredient("silk", 3), Ingredient("rope", 2)},
    TECH.SCIENCE_TWO,
    nil,
    {"TOOLS", "FISHING"}
)
ChangeSortKey("driftwoodfishingrod", "fishingrod", "TOOLS", true)
ChangeSortKey("driftwoodfishingrod", "fishingrod", "FISHING", true)

AddRecipe2(
    "uncompromising_fishingnet",
    {Ingredient("rope", 1), Ingredient("rocks", 2), Ingredient("silk", 3)},
    TECH.SCIENCE_ONE,
    nil,
    {"TOOLS", "FISHING"}
)
ChangeSortKey("uncompromising_fishingnet", "driftwoodfishingrod", "TOOLS", true)
ChangeSortKey("uncompromising_fishingnet", "driftwoodfishingrod", "FISHING", true)

--[[
AddRecipe2(
    "uncompromising_harpoon",
    {Ingredient("twigs", 2), Ingredient("rope", 2), Ingredient("flint", 1)},
    TECH.SCIENCE_TWO,
    nil,
    {"TOOLS", "FISHING"}
)
ChangeSortKey("uncompromising_harpoon", "uncompromising_fishingnet", "TOOLS", true)

AddRecipe2(
    "uncompromising_harpoon_heavy",
    {Ingredient("twigs", 2), Ingredient("goldnugget", 3), Ingredient("flint", 1)},
    TECH.SCIENCE_TWO,
    nil,
    {"TOOLS", "FISHING"}
)
ChangeSortKey("uncompromising_harpoon_heavy", "uncompromising_harpoon", "TOOLS", true)]]

AddRecipe2(
    "um_magnerang",
    {Ingredient("boomerang", 1), Ingredient("transistor", 2), Ingredient("steelwool", 3)},
    TECH.SCIENCE_TWO,
    nil,
    {"WEAPONS"}
)
ChangeSortKey("um_magnerang", "boomerang", "WEAPONS", true)

AddRecipe2(
    "hermitshop_rain_horn",
    {Ingredient("dormant_rain_horn", 1), Ingredient("oceanfish_small_9_inv", 3), Ingredient("messagebottleempty", 2)},
    TECH.HERMITCRABSHOP_SEVEN,
    {nounlock = true, product = "rain_horn"},
    {"CRAFTING_STATION"}
)
ChangeSortKey("hermitshop_rain_horn", "hermitshop_oceanfishingbobber_malbatross", "CRAFTING_STATION", true)

AddRecipe2(
    "hat_ratmask",
    {Ingredient("rope", 2), Ingredient("beardhair", 3), Ingredient("sewing_kit", 1)},
    TECH.SCIENCE_TWO,
    nil,
    {"CLOTHING"}
)
ChangeSortKey("hat_ratmask", "plaguemask", "CLOTHING", true)

AddRecipe2(
    "floral_bandage",
    {Ingredient("bandage", 1), Ingredient("cactus_flower", 2)},
    TECH.SCIENCE_TWO,
    nil,
    {"RESTORATION"}
)
ChangeSortKey("floral_bandage", "bandage", "RESTORATION", true)

AddRecipe2(
    "winona_toolbox",
    {Ingredient("boards", 2), Ingredient("goldnugget", 4), Ingredient("sewing_tape", 2)},
    TECH.NONE,
    {builder_tag = "handyperson"},
    {"CONTAINERS", "CHARACTER"}
)
ChangeSortKey("winona_toolbox", "treasurechest", "CONTAINERS", true)
ChangeSortKey("winona_toolbox", "sewing_tape", "CHARACTER", true)

AddRecipe2(
    "powercell",
    {Ingredient("sewing_tape", 1), Ingredient("goldnugget", 1), Ingredient("nitre", 2)},
    TECH.NONE,
    {builder_tag = "handyperson", numtogive = 3},
    {"CHARACTER"}
)
ChangeSortKey("powercell", "winona_battery_high", "CHARACTER", true)

AddRecipe2(
    "winona_upgradekit_electrical",
    {Ingredient("goldnugget", 6), Ingredient("sewing_tape", 2), Ingredient("trinket_6", 2)},
    TECH.SCIENCE_TWO,
    {builder_tag = "handyperson"},
    {"CHARACTER", "LIGHT"}
)
ChangeSortKey("winona_upgradekit_electrical", "winona_toolbox", "CHARACTER", true)

AddRecipeToFilter("wardrobe", "CONTAINERS")
ChangeSortKey("wardrobe", "icebox", "CONTAINERS", false)

AddRecipeToFilter("tophat", "MAGIC")
ChangeSortKey("tophat", "armorslurper", "MAGIC", true)

AddRecipeToFilter("wall_hay_item", "WINTER")
ChangeSortKey("wall_hay_item", "dragonflyfurnace", "WINTER", true)
AddRecipeToFilter("wall_wood_item", "WINTER")
ChangeSortKey("wall_wood_item", "wall_hay_item", "WINTER", true)
AddRecipeToFilter("wall_stone_item", "WINTER")
ChangeSortKey("wall_stone_item", "wall_wood_item", "WINTER", true)
AddRecipeToFilter("wall_moonrock_item", "WINTER")
ChangeSortKey("wall_moonrock_item", "wall_stone_item", "WINTER", true)

AddRecipe2(
    "boatpatch_sludge",
    {Ingredient("sludge", 3), Ingredient("driftwood_log", 2)},
    TECH.NONE,
     nil, --{numtogive = 2},
    {"SEAFARING"}
)
ChangeSortKey("boatpatch_sludge", "oar", "SEAFARING", false)

AddRecipe2(
    "sludge_sack",
    {Ingredient("sludge", 6), Ingredient("rockjawleather", 2), Ingredient("rope", 3)},
    TECH.SCIENCE_TWO,
    nil,
    {"CONTAINERS", "CLOTHING"}
)
ChangeSortKey("sludge_sack", "piggyback", "CONTAINERS", true)
ChangeSortKey("sludge_sack", "piggyback", "CLOTHING", true)

AddRecipe2(
    "boat_bumper_sludge_kit",
    {Ingredient("sludge", 4), Ingredient("driftwood_log", 2)},
    TECH.SEAFARING_ONE,
    {numtogive = 2},
    {"SEAFARING"}
)
ChangeSortKey("boat_bumper_sludge_kit", "boat_bumper_shell_kit", "SEAFARING", true)

AddRecipe2(
    "cannonball_sludge_item",
    {Ingredient("sludge", 2), Ingredient("nitre", 1), Ingredient("charcoal", 1)},
    TECH.SEAFARING_ONE,
    {numtogive = 4},
    {"WEAPONS", "SEAFARING"}
)
ChangeSortKey("cannonball_sludge_item", "cannonball_rock_item", "SEAFARING", true)
ChangeSortKey("cannonball_sludge_item", "cannonball_rock_item", "WEAPONS", true)

AddRecipe2(
  "sludge_oil",
  {Ingredient("sludge", 3), Ingredient("messagebottleempty", 1)},
  TECH.SCIENCE_TWO,
  nil,
  {"TOOLS", "LIGHT"}
)
ChangeSortKey("sludge_oil", "sewing_tape", "TOOLS", true)
ChangeSortKey("sludge_oil", "coldfirepit", "LIGHT", true)

AddRecipe2(
    "armor_reed_um",
    {Ingredient("cutreeds", 8), Ingredient("twigs", 3)},
    TECH.NONE,
    nil,
    {"ARMOUR", "RAIN"}
)
ChangeSortKey("armor_reed_um", "armorgrass", "ARMOUR", true)
ChangeSortKey("armor_reed_um", "raincoat", "RAIN", true)

--ChangeSortKey("PREFAB_NAME_OF_ITEM_THAT_YOURE_SORTING","PREFAB_NAME_OF_ITEM_YOU_VVANT_IT_TO_GO_AFTER","THE_TAB",true) you need to do this for each tab that you vvant it to be sorted in -AXE
--need to add the inv atlases

AddRecipe2(
    "armor_sharksuit_um",
    {Ingredient("armorwood", 1), Ingredient("rockjawleather", 1), Ingredient("sludge", 4)},
    TECH.SCIENCE_TWO,
    nil,
    {"SEAFARING", "ARMOUR", "RAIN"}
)
ChangeSortKey("armor_sharksuit_um", "armordragonfly", "ARMOUR", true)
ChangeSortKey("armor_sharksuit_um", "balloonvest", "SEAFARING", true)
ChangeSortKey("armor_sharksuit_um", "armor_reed_um", "RAIN", true)

AddRecipe2(
    "brine_balm",
    {Ingredient("saltrock", 2), Ingredient("kelp", 1)},--, Ingredient("driftwood_log", 1)
    TECH.SCIENCE_ONE,
    nil, --{numtogive = 2},
    {"RESTORATION"}
)
ChangeSortKey("brine_balm", "floral_bandage", "RESTORATION", true)

AddRecipe2(
    "sludge_cork",
    {Ingredient("driftwood_log", 2), Ingredient("rope", 2)},
    TECH.SCIENCE_ONE,
    nil,
    {"TOOLS","SEAFARING"}
)
ChangeSortKey("sludge_cork", "oceanfishingrod", "TOOLS", true)
ChangeSortKey("sludge_cork", "boat_magnet_beacon", "SEAFARING", true)

--[[
AddRecipe2(--unsure...
    "trinket_6",
    {Ingredient("um_copper_pipe", 3)},
    TECH.SCIENCE_TWO,
    {numtogive = 2},
    {"REFINE"}
)
ChangeSortKey("trinket_6", "transistor", "REFINE", true)]]

--deconstruct recipes
AddDeconstructRecipe("cursed_antler", {Ingredient("boneshard", 8), Ingredient("nightmarefuel", 2)})
AddDeconstructRecipe("beargerclaw", {Ingredient("boneshard", 4), Ingredient("furtuft", 8)})
AddDeconstructRecipe("klaus_amulet", {Ingredient("goldnugget", 4), Ingredient("nightmarefuel", 6)})
AddDeconstructRecipe("feather_frock", {Ingredient("goose_feather", 6)})
AddDeconstructRecipe("gore_horn_hat", {Ingredient("meat", 2), Ingredient("nightmarefuel", 4)})
AddDeconstructRecipe("crabclaw", {Ingredient("rocks", 4), Ingredient("cutstone", 1)})
AddDeconstructRecipe("slobberlobber", {Ingredient("dragon_scales", 1), Ingredient("meat", 1)})
AddDeconstructRecipe("um_beegun", {Ingredient("honeycomb", 6),Ingredient("royal_jelly", 2)})

AddDeconstructRecipe("shadow_crown", {Ingredient("nightmarefuel", 5),Ingredient("beardhair", 3)})
AddDeconstructRecipe("rain_horn", {Ingredient("slurtle_shellpieces", 4),Ingredient("rocks", 2),Ingredient("oceanfish_small_9_inv", 3)})
AddDeconstructRecipe("dormant_rain_horn", {Ingredient("cookiecuttershell", 4),Ingredient("rocks", 2)})

----deconstruct recipes for craftable items
AddDeconstructRecipe("steeringwheel_copper", {Ingredient("um_copper_pipe", 3), Ingredient("gears", 1)})

--Sailing Rebalance related recipes.

--trident buff
AllRecipes["trident"].ingredients = {Ingredient("boneshard", 2), Ingredient("gnarwail_horn", 1), Ingredient("twigs", 4)}

--hermitshop expansion
AddRecipe2(
    "hermitshop_hermit_bundle_lures",
    {Ingredient("messagebottleempty", 1)},
    TECH.HERMITCRABSHOP_ONE,
    {nounlock = true, numtogive = 1, product = "hermit_bundle_lures", sg_state = "give", image = "hermit_bundle.tex"}
)
ChangeSortKey("hermitshop_hermit_bundle_lures", "hermitshop_hermit_bundle_shells", "CRAFTING_STATION", false)

AddRecipe2(
    "hermitshop_boat",
    {Ingredient("messagebottleempty", 1)},
    TECH.HERMITCRABSHOP_ONE,
    {nounlock = true, product = "boat_item", sg_state = "give"}
)
ChangeSortKey("hermitshop_boat", "hermitshop_hermit_bundle_shells", "CRAFTING_STATION", true)

AddRecipe2(
    "hermitshop_mast",
    {Ingredient("messagebottleempty", 1)},
    TECH.HERMITCRABSHOP_ONE,
    {nounlock = true, product = "mast_item", sg_state = "give"}
)
ChangeSortKey("hermitshop_mast", "hermitshop_boat", "CRAFTING_STATION", true)

AddRecipe2(
    "hermitshop_anchor",
    {Ingredient("messagebottleempty", 1)},
    TECH.HERMITCRABSHOP_ONE,
    {nounlock = true, product = "anchor_item", sg_state = "give"}
)
ChangeSortKey("hermitshop_anchor", "hermitshop_mast", "CRAFTING_STATION", true)

AddRecipe2(
    "hermitshop_steeringwheel",
    {Ingredient("messagebottleempty", 1)},
    TECH.HERMITCRABSHOP_ONE,
    {nounlock = true, product = "steeringwheel_item", sg_state = "give"}
)
ChangeSortKey("hermitshop_steeringwheel", "hermitshop_anchor", "CRAFTING_STATION", true)

AddRecipe2(
    "hermitshop_patch",
    {Ingredient("messagebottleempty", 1)},
    TECH.HERMITCRABSHOP_ONE,
    {nounlock = true, product = "boatpatch", sg_state = "give", numtogive = 3}
)
ChangeSortKey("hermitshop_patch", "hermitshop_steeringwheel", "CRAFTING_STATION", true)

AddRecipe2(
    "hermitshop_blueprint",
    {Ingredient("messagebottleempty", 1)},
    GLOBAL.TECH.HERMITCRABSHOP_THREE,
    {nounlock = true, product = "blueprint", sg_state = "give"}
)
ChangeSortKey("hermitshop_blueprint", "hermitshop_turf_shellbeach_blueprint", "CRAFTING_STATION", true)

AddRecipe2(
    "hermitshop_waterplant",
    {Ingredient("messagebottleempty", 3)},
    TECH.HERMITCRABSHOP_FIVE,
    {nounlock = true, product = "waterplant_planter", sg_state = "give"}
)
ChangeSortKey("hermitshop_waterplant", "hermitshop_chum", "CRAFTING_STATION", true)

AddRecipe2(
    "hermitshop_cookies",
    {Ingredient("messagebottleempty", 1)},
    TECH.HERMITCRABSHOP_SEVEN,
    {nounlock = true, product = "pumpkincookie", sg_state = "give"}
)
ChangeSortKey("hermitshop_cookies", "hermitshop_supertacklecontainer", "CRAFTING_STATION", true)

AddRecipe2(
    "normal_chum",
    {Ingredient("spoiled_food", 2), Ingredient("rope", 1), Ingredient("waterplant_bomb", 1)},
    TECH.FISHING_ONE,
    {product = "chum", nounlock = false, numtogive = 2},
    {"FISHING"}
)
AllRecipes["chum"].ingredients = {Ingredient("spoiled_food", 1), Ingredient("rope", 1), Ingredient("waterplant_bomb", 1)}
AllRecipes["hermitshop_chum"].ingredients = {Ingredient("messagebottleempty", 1)}
AllRecipes["hermitshop_chum"].numtogive = 3
--[[
AddRecipe2(
    "hermitshop_oil",
    {Ingredient("messagebottleempty", 3)},
    TECH.HERMITCRABSHOP_FIVE,
    {nounlock = true, product = "diseasecurebomb", sg_state = "give"}
)
ChangeSortKey("hermitshop_oil", "hermitshop_cookies", "CRAFTING_STATION", true)]]

--better moonstorm
AddRecipe2(
    "moonstorm_static_item",
    {Ingredient("transistor", 1), Ingredient("moonstorm_spark", 2), Ingredient("goldnugget", 3)},
    TECH.LOST,
    nil,
    {"REFINE"}
)
AddRecipe2(
    "alterguardianhatshard",
    {Ingredient("moonglass_charged", 1), Ingredient("moonstorm_spark", 2), Ingredient("lightbulb", 1)},
    TECH.LOST,
    nil,
    {"LIGHT", "REFINE"}
)

AddDeconstructRecipe("alterguardianhat", {Ingredient("alterguardianhatshard", 5), Ingredient("alterguardianhatshard_blueprint", 1)})

AddRecipe2(
    "critter_figgy_builder",
    {Ingredient("steelwool", 1), Ingredient("blueberrypancakes", 1)},
    TECH.ORPHANAGE_ONE,
	{nounlock=true, actionstr="ORPHANAGE"}
)
ChangeSortKey("critter_figgy_builder", "critter_eyeofterror_builder", "CRAFTING_STATION", true)

AddRecipe2("portableboat_item", {Ingredient("mosquitosack", 2), Ingredient("rope", 2)}, TECH.SEAFARING_ONE, nil, {"SEAFARING"})
ChangeSortKey("portableboat_item", "boat_item", "SEAFARING", true)

AddRecipe2("mastupgrade_windturbine_item", {Ingredient("cutstone", 2), Ingredient("transistor", 2)}, TECH.SEAFARING_ONE, nil, {"SEAFARING"})
ChangeSortKey("mastupgrade_windturbine_item", "mastupgrade_lightningrod_item", "SEAFARING", true)
--recipe postinits

AddRecipePostInitAny(function(recipe)
    if recipe.FindAndConvertIngredient ~= nil then
        local tar = recipe:FindAndConvertIngredient("tar")--tar/sludge can replace eachother!
        local sludge = recipe:FindAndConvertIngredient("sludge")

        if tar and tar.AddDictionaryPrefab ~= nil then
            tar:AddDictionaryPrefab("sludge")
        end

        if sludge and sludge.AddDictionaryPrefab ~= nil then
            if GLOBAL.Prefabs["tar"] ~= nil then
                sludge:AddDictionaryPrefab("tar")
            end
        end
    end
end)

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
STRINGS.RECIPE_DESC.UNCOMPROMISING_FISHINGNET = "Nothing but net!"
STRINGS.RECIPE_DESC.UNCOMPROMISING_HARPOON = "Keel Haul 'Em!"
STRINGS.RECIPE_DESC.UNCOMPROMISING_HARPOON_HEAVY = "Up for a Chain'ge?"
STRINGS.RECIPE_DESC.UM_MAGNERANG = "Mutual Attraction!"
STRINGS.RECIPE_DESC.BOOK_RAIN_UM = "A catalogue of weather effects."
STRINGS.RECIPE_DESC.RAIN_HORN = "Drown the world."
STRINGS.RECIPE_DESC.HAT_RATMASK = "Sniff out some vermin!"
STRINGS.RECIPE_DESC.FLORAL_BANDAGE = "Sweetened healing!"
STRINGS.RECIPE_DESC.WINONA_TOOLBOX = "An engineer is always prepared."
STRINGS.RECIPE_DESC.POWERCELL = "Portable electricity!"
STRINGS.RECIPE_DESC.WINONA_UPGRADEKIT_ELECTRICAL = "Any old light source can be electric now."
STRINGS.RECIPE_DESC.BOATPATCH_SLUDGE = "For when your boat has a hole that shouldn't be there."
STRINGS.RECIPE_DESC.ARMOR_REED_UM = "Waterproof protection."
STRINGS.RECIPE_DESC.ARMOR_SHARKSUIT_UM = "Become the shark."
STRINGS.RECIPE_DESC.SLUDGE_SACK = "Thieves turn up with nothing but sticky fingers."
STRINGS.RECIPE_DESC.BOAT_BUMPER_SLUDGE_KIT = "Cushion the blow."
STRINGS.RECIPE_DESC.SLUDGE_OIL = "Only the purest sludge."
STRINGS.RECIPE_DESC.SLUDGE_CORK = "Impractically large for a boat."
STRINGS.RECIPE_DESC.CANNONBALL_SLUDGE_ITEM = "Fire in the hole!"
STRINGS.RECIPE_DESC.BRINE_BALM = "Rub salt in the wounds."
STRINGS.RECIPE_DESC.CRITTER_FIGGY_BUILDER = "They like to put holes in things."
STRINGS.RECIPE_DESC.BOAT_BUMBER_SLUDGE_KIT = "Sticky protection."
STRINGS.RECIPE_DESC.BOAT_BUMPER_COPPER_KIT = "Sturdy protection."
STRINGS.RECIPE_DESC.STEERINGWHEEL_COPPER_ITEM = "Steer more than your masts."
STRINGS.RECIPE_DESC.TRINKET_6 = "A key ingredient for modern marvels."
STRINGS.RECIPE_DESC.PORTABLEBOAT_ITEM = "Pack up and go!"
STRINGS.RECIPE_DESC.MASTUPGRADE_WINDTURBINE_ITEM = "Full speed ahead!"

--sailing rebalance strings
STRINGS.RECIPE_DESC.MOONSTORM_STATIC_ITEM = "The power of the moon, contained!"
STRINGS.RECIPE_DESC.ALTERGUARDIANHATSHARD = "Harness the moonlight."
STRINGS.RECIPE_DESC.WATERPLANT_PLANTER = "Grow your very own Sea Weed."
STRINGS.RECIPE_DESC.BLUEPRINT = "Learn new things."
STRINGS.RECIPE_DESC.PUMPKINCOOKIE = "Grandma's cookies."
STRINGS.RECIPE_DESC.HERMIT_BUNDLE_LURES = "Get to fishing, today!"

GLOBAL.PROTOTYPER_DEFS.critterlab_real = GLOBAL.PROTOTYPER_DEFS.critterlab