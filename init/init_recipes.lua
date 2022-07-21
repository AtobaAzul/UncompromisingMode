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

modimport("uncompskins_api.lua")

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

if GetModConfigData("longpig") then
    AllRecipes["reviver"].ingredients = {Ingredient("skeletonmeat", 1), Ingredient("spidergland", 1)}
end
if GetModConfigData("wanda_nerf") then
    AllRecipes["pocketwatch_revive"].ingredients = {
        Ingredient("pocketwatch_parts", 2),
        Ingredient("livinglog", 2),
        Ingredient("boneshard", 4)
    }
end

AllRecipes["moonrockidol"].ingredients = {
    Ingredient("moonrocknugget", GLOBAL.TUNING.DSTU.RECIPE_MOONROCK_IDOL_MOONSTONE_COST),
    Ingredient("purplegem", 1)
}
AllRecipes["minifan"].ingredients = {Ingredient("twigs", 3), Ingredient("petals", 4)}
AllRecipes["seedpouch"].ingredients = {
    Ingredient("slurtle_shellpieces", 2),
    Ingredient("waxpaper", 1),
    Ingredient("seeds", 2)
}
AllRecipes["catcoonhat"].ingredients = {Ingredient("coontail", 4), Ingredient("silk", 4)}
AllRecipes["goggleshat"].ingredients = {
    Ingredient("goldnugget", 4),
    Ingredient("pigskin", 1),
    Ingredient("houndstooth", 2)
}
AllRecipes["deserthat"].level = TechTree.Create(TECH.SCIENCE_TWO)

if TUNING.DSTU.WOLFGANG_HUNGERMIGHTY then
    AllRecipes["mighty_gym"].ingredients = {Ingredient("boards", 4), Ingredient("cutstone", 2), Ingredient("rope", 3)}
    AllRecipes["dumbbell"].ingredients = {Ingredient("rocks", 4), Ingredient("twigs", 1)}
    AllRecipes["dumbbell_golden"].ingredients = {
        Ingredient("goldnugget", 2),
        Ingredient("cutstone", 2),
        Ingredient("twigs", 2)
    }
    AllRecipes["dumbbell_gem"].ingredients = {
        Ingredient("purplegem", 1),
        Ingredient("cutstone", 2),
        Ingredient("twigs", 2)
    }
end

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

AddRecipe2(
    "ghostlyelixir_fastregen",
    {Ingredient(GLOBAL.CHARACTER_INGREDIENT.HEALTH, 50), Ingredient("ghostflower", 4)},
    TECH.MAGIC_TWO,
    {builder_tag = "elixirbrewer"},
    {"CHARACTER"}
)

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
    "slingshotammo_firecrackers",
    {Ingredient("nitre", 2)},
    GLOBAL.TECH.SCIENCE_TWO,
    {builder_tag = "pebblemaker", numtogive = 10},
    {"CHARACTER"}
)
ChangeSortKey("slingshotammo_firecrackers", "slingshotammo_poop", "CHARACTER", false)

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
    {Ingredient("twigs", 1), Ingredient("foliage", 1), Ingredient("moonrocknugget", 1)},
    TECH.TURFCRAFTING_TWO,
    {numtogive = 4},
    {"DECOR"}
)
ChangeSortKey("turf_hoodedmoss", "turf_deciduous", "DECOR", true)

AddRecipe2(
    "turf_ancienthoodedturf",
    {Ingredient("turf_hoodedmoss", 1), Ingredient("moonrocknugget", 1), Ingredient("thulecite_pieces", 1)},
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

if not TUNING.DSTU.UPDATE_CHECK then
    AddRecipe2(
        "book_rain_um",
        {Ingredient("papyrus", 2), Ingredient("moon_tear", 1), Ingredient("waterballoon", 4)},
        TECH.MAGIC_THREE,
        {builder_tag = "bookbuilder"},
        {"CHARACTER"}
    )
    ChangeSortKey("book_rain_um", "book_tentacles", "CHARACTER", true)
else
    if GetModConfigData("legacy_book_rain_recipe") then
        AllRecipes["book_rain"].ingredients = {Ingredient("papyrus", 2), Ingredient("moon_tear", 1), Ingredient("waterballoon", 4)}
        AllRecipes["book_rain"].level = TechTree.Create(TECH.MAGIC_THREE)
    end
end

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
    "hermitshop_rain_horn",
    {Ingredient("dormant_rain_horn", 1), Ingredient("oceanfish_small_9_inv", 3), Ingredient("messagebottleempty", 2)},
    TECH.HERMITCRABSHOP_SEVEN,
    {nounlock = true, product = "rain_horn"},
    {"CRAFTING_STATION"}
)
ChangeSortKey("hermitshop_rain_horn", "hermitshop_oceanfishingbobber_malbatross", "CRAFTING_STATION", true)

AddRecipe2(
    "hat_ratmask",
    {Ingredient("rope", 2), Ingredient("rat_tail", 3), Ingredient("sewing_kit", 1)},
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

ChangeSortKey("winona_toolbox", "treasurechest", "CONTAINERS", false)

AddRecipeToFilter("wardrobe", "CONTAINERS")
ChangeSortKey("wardrobe", "icebox", "CONTAINERS", false)

--deconstruct recipes
AddDeconstructRecipe("cursed_antler", {Ingredient("boneshard", 8), Ingredient("nightmarefuel", 2)})
AddDeconstructRecipe("beargerclaw", {Ingredient("boneshard", 2), Ingredient("furtuft", 2)})
AddDeconstructRecipe("klaus_amulet", {Ingredient("cutstone", 1), Ingredient("nightmarefuel", 6)})
AddDeconstructRecipe("feather_frock", {Ingredient("goose_feather", 6)})
AddDeconstructRecipe("gore_horn_hat", {Ingredient("meat", 2), Ingredient("nightmarefuel", 4)})
AddDeconstructRecipe("crabclaw", {Ingredient("rocks", 4), Ingredient("cutstone", 1)})
AddDeconstructRecipe("slobberlobber", {Ingredient("dragon_scales", 1), Ingredient("meat", 2)})

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
STRINGS.RECIPE_DESC.BOOK_RAIN_UM = "A catalogue of weather effects."
STRINGS.RECIPE_DESC.RAIN_HORN = "Drown the world."
STRINGS.RECIPE_DESC.HAT_RATMASK = "Sniff out some vermin!"
STRINGS.RECIPE_DESC.FLORAL_BANDAGE = "Sweetened Healing!"