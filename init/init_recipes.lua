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

-- Recipe changes
if GetModConfigData("longpig") then
    AllRecipes["reviver"].ingredients = {
        Ingredient("skeletonmeat", 1),
        Ingredient("spidergland", 1)
    }
end

if GetModConfigData("compostoverrot") then
    -- Rot Related Recipe Changes [AXE]
    AllRecipes["lifeinjector"].ingredients = {
        Ingredient("nitre", 2),
        Ingredient("red_cap", 6),
        Ingredient("stinger", 1),
    }
    AllRecipes["mushroom_farm"].ingredients = {
        Ingredient("compost", 4),
        Ingredient("poop", 5),
        Ingredient("livinglog", 2),
    }
    AllRecipes["compostwrap"].ingredients = {
        Ingredient("poop", 5),
        Ingredient("compost", 1),
        Ingredient("nitre", 1),
    }
    AllRecipes["compostingbin"].ingredients = {
        Ingredient("boards", 3),
        Ingredient("twigs", 2),
        Ingredient("cutgrass", 1),
    }

    --wormwood stuffs
    AllRecipes["ipecacsyrup"].ingredients = { Ingredient("red_cap", 1), Ingredient("honey", 1), Ingredient("compost", 1) }
    AllRecipes["wormwood_berrybush"].ingredients = { Ingredient("compost", 2), Ingredient("berries_juicy", 8) }
    AllRecipes["wormwood_berrybush2"].ingredients = { Ingredient("compost", 2), Ingredient("berries_juicy", 8) }
    AllRecipes["wormwood_juicyberrybush"].ingredients = { Ingredient("compost", 2), Ingredient("berries", 8) }

    --turf
    AllRecipes["turf_marsh"].ingredients = { Ingredient("cutreeds", 1), Ingredient("compost", 1) }
    AllRecipes["wurt_turf_marsh"].ingredients = { Ingredient("cutreeds", 1), Ingredient("compost", 1) }
end

--woodie stuff

local config_skilltrees = GetModConfigData("woodie_skilltree")
if config_skilltrees then
	AllRecipes["walking_stick"].ingredients = { Ingredient("lucy", 0), Ingredient("log", 3), Ingredient("wereitem_goose", 1) }
end

if GetModConfigData("wanda_nerf") then
    AllRecipes["pocketwatch_revive"].ingredients = {
        Ingredient("pocketwatch_parts", 3),
        Ingredient("livinglog", 2),
        Ingredient("boneshard", 4)
    }
end

if TUNING.DSTU.GOTOBED ~= false then
	AllRecipes["siestahut"].ingredients = {
        Ingredient("silk", 6),
        Ingredient("boards", 4),
        Ingredient("rope", 3)
    }		
		
end

if GetModConfigData("beebox_nerf") then
    AllRecipes["beebox"].ingredients = {
        Ingredient("boards", 2),
        Ingredient("honeycomb", 1),
        Ingredient("bee", 2)
    }
end

AllRecipes["moonrockidol"].ingredients = {
    Ingredient("moonrocknugget", GLOBAL.TUNING.DSTU.RECIPE_MOONROCK_IDOL_MOONSTONE_COST),
    Ingredient("purplegem", 1)
}

AllRecipes["minifan"].ingredients = {
    Ingredient("twigs", 3),
    Ingredient("petals", 4)
}

AllRecipes["seedpouch"].ingredients = {
    Ingredient("slurtle_shellpieces", 2),
    Ingredient("waxpaper", 1),
    Ingredient("seeds", 2)
}

AllRecipes["catcoonhat"].ingredients = {
    Ingredient("coontail", 4),
    Ingredient("silk", 4)
}

AllRecipes["goggleshat"].ingredients = {
    Ingredient("goldnugget", 4),
    Ingredient("pigskin", 1),
    Ingredient("houndstooth", 2)
}

AllRecipes["deserthat"].level = TechTree.Create(TECH.SCIENCE_TWO)

AllRecipes["saddle_race"].ingredients = {
    Ingredient("livinglog", 2),
    Ingredient("silk", 4),
    Ingredient("glommerwings", 1)
}

AllRecipes["battlesong_fireresistance"].ingredients = {
    Ingredient("papyrus", 1),
    Ingredient("featherpencil", 1),
    Ingredient("dragon_scales", 1)
}

AllRecipes["walterhat"].ingredients = {
    Ingredient("silk", 4),
    Ingredient("pinecone", 1)
}

if GetModConfigData("wicker_inv_regen") ~= "vanilla" then
    AllRecipes["bookstation"].ingredients = {
        Ingredient("boards", 4),
        Ingredient("papyrus", 4),
        Ingredient("featherpencil", 1)
    }
end

if GetModConfigData("applied horticulture") then
    AllRecipes["book_horticulture"].ingredients = {
        Ingredient("papyrus", 2),
        Ingredient("plantmeat", 1),
        Ingredient("poop", 5)
    }
end

if GetModConfigData("horticulture, expanded") then
    AllRecipes["book_horticulture_upgraded"].ingredients = {
        Ingredient("book_horticulture", 1),
        Ingredient("treegrowthsolution", 1),
        Ingredient("papyrus", 2)
    }
end

if GetModConfigData("the angler") then
    AllRecipes["book_fish"].ingredients = {
        Ingredient("papyrus", 2),
        Ingredient("oceanfishingbobber_oval", 2)
    }
end

if GetModConfigData("lux aeterna") then
    AllRecipes["book_light_upgraded"].ingredients = {
        Ingredient("book_light", 1),
        Ingredient("wormlight", 1),
        Ingredient("papyrus", 2)
    }
end

if GetModConfigData("lunar grimoire") then
    AllRecipes["book_moon"].ingredients = {
        Ingredient("papyrus", 2),
        Ingredient("moonrocknugget", 2),
        Ingredient("moon_cap", 2)
    }
end

if GetModConfigData("apicultural notes") then
    AllRecipes["book_bees"].ingredients = {
        Ingredient("papyrus", 2),
        Ingredient("honeycomb", 1),
        Ingredient("stinger", 8)
    }
end

-- magnets and dock
if GetModConfigData("no4crafts") then -- :desolate:
    AllRecipes["dock_kit"].ingredients = {
        Ingredient("boards", 4),
        Ingredient("stinger", 2),
        Ingredient("palmcone_scale", 4)
    }
    --[[AllRecipes["boat_magnet_kit"].ingredients = {
     Ingredient("gears", 1),
     Ingredient("transistor", 2),
     Ingredient("um_copper_pipe", 3)--copper isn't fucking obtainable yet what the fuck
}
AllRecipes["boat_magnet_beacon"].ingredients = {
     Ingredient("messagebottleempty", 1),
     Ingredient("transistor", 1),
     Ingredient("um_copper_pipe", 1)
}]]
end

AllRecipes["boat_bumper_shell_kit"].numtogive = 4 -- 8
AllRecipes["boat_bumper_kelp_kit"].numtogive = 4  -- 8
AllRecipes["boat_bumper_shell_kit"].ingredients = {
    Ingredient("slurtle_shellpieces", 3),
    Ingredient("rope", 3)
}
AllRecipes["boat_bumper_kelp_kit"].ingredients = {
    Ingredient("kelp", 3),
    Ingredient("cutgrass", 6)
}

if TUNING.DSTU.WOLFGANG_HUNGERMIGHTY then
    AllRecipes["mighty_gym"].ingredients = { Ingredient("boards", 4), Ingredient("cutstone", 2), Ingredient("rope", 3) }
    AllRecipes["dumbbell"].ingredients = { Ingredient("rocks", 4), Ingredient("twigs", 1) }
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

if GetModConfigData("telestaff_rework") then
    AllRecipes["telebase"].ingredients = {
        Ingredient("purplegem", 3),
        Ingredient("livinglog", 4),
        Ingredient("nightmarefuel", 4)
    }
    AllRecipes["telestaff"].ingredients = {
        Ingredient("nightmarefuel", 2),
        Ingredient("spear", 1),
        Ingredient("purplegem", 1)
    }
    AllRecipes["purpleamulet"].ingredients = {
        Ingredient("goldnugget", 3),
        Ingredient("nightmarefuel", 2),
        Ingredient("purplegem", 1)
    }
end

if GetModConfigData("longpig") then
    AddRecipe2(
        "ghostlyelixir_fastregen",
        { Ingredient(GLOBAL.CHARACTER_INGREDIENT.HEALTH, 50), Ingredient("ghostflower", 4) },
        TECH.NONE,
        { builder_tag = "elixirbrewer" },
        { "CHARACTER" }
    )
end

local winona_portables = { "battery_high", "battery_low", "spotlight", "catapult" }
if GetModConfigData("winona_portables_") then
    for k, v in ipairs(winona_portables) do
        AllRecipes["winona_" .. v].product = "winona_" .. v .. "_item"
        AllRecipes["winona_" .. v].placer = nil
    end
end

AllRecipes["mast_item"].ingredients = { Ingredient("log", 3), Ingredient("rope", 2), Ingredient("silk", 3) }
AllRecipes["mast"].ingredients = { Ingredient("log", 3), Ingredient("rope", 2), Ingredient("silk", 3) }

AllRecipes["mast_malbatross_item"].ingredients = {
    Ingredient("driftwood_log", 3),
    Ingredient("rope", 2),
    Ingredient("malbatross_feathered_weave", 3)
}
AllRecipes["mast_malbatross"].ingredients = {
    Ingredient("driftwood_log", 3),
    Ingredient("rope", 2),
    Ingredient("malbatross_feathered_weave", 3)
}

AllRecipes["winona_spotlight"].ingredients = { Ingredient("sewing_tape", 1), Ingredient("goldnugget", 2), Ingredient("lightbulb", 1) }

AllRecipes["featherpencil"].numtogive = 4 -- 8


-- new recipes

if GetModConfigData("snowstorms") then
    AddRecipe2(
        "snowgoggles",
        { Ingredient("catcoonhat", 1), Ingredient("goggleshat", 1), Ingredient("beefalowool", 2) },
        TECH.SCIENCE_TWO,
        nil,
        { "WINTER", "CLOTHING" }
    )
    ChangeSortKey("snowgoggles", "catcoonhat", "WINTER", true)
    ChangeSortKey("snowgoggles", "catcoonhat", "CLOTHING", true)
end

if GetModConfigData("rat_raids") then
    AddRecipe2(
        "ratpoisonbottle",
        { Ingredient("red_cap", 2), Ingredient("jammypreserves", 1), Ingredient("rocks", 1) },
        TECH.SCIENCE_ONE,
        nil,
        { "TOOLS" }
    )
    ChangeSortKey("ratpoisonbottle", "trap", "TOOLS", true)
end

AddRecipe2(
    "diseasecurebomb",
    { Ingredient("cactus_flower", 2), Ingredient("moonrocknugget", 2), Ingredient("spidergland", 3) },
    TECH.SCIENCE_TWO,
    nil,
    { "GARDENING", "TOOLS", "RESTORATION" }
)
ChangeSortKey("diseasecurebomb", "compostwrap", "GARDENING", true)
ChangeSortKey("diseasecurebomb", "premiumwateringcan", "TOOLS", true)
ChangeSortKey("diseasecurebomb", "lifeinjector", "RESTORATION", true)

if GetModConfigData("snowstorms") then
    AddRecipe2("ice_snowball", { Ingredient("snowball_throwable", 4) }, TECH.SCIENCE_ONE, { product = "ice" },
        { "REFINE" })
    ChangeSortKey("ice_snowball", "beeswax", "REFINE", true)
end

AddRecipe2(
    "gasmask",
    { Ingredient("goose_feather", 10), Ingredient("red_cap", 2), Ingredient("pigskin", 2) },
    TECH.SCIENCE_TWO,
    nil,
    { "CLOTHING", "RAIN", "SUMMER" }
)
ChangeSortKey("gasmask", "beehat", "CLOTHING", true)
ChangeSortKey("gasmask", "beehat", "RAIN", true)

AddRecipe2(
    "plaguemask",
    { Ingredient("gasmask", 1), Ingredient("red_cap", 2), Ingredient("rat_tail", 4) },
    TECH.SCIENCE_TWO,
    nil,
    { "CLOTHING", "RAIN", "SUMMER" }
)
ChangeSortKey("plaguemask", "gasmask", "CLOTHING", true)
ChangeSortKey("plaguemask", "gasmask", "RAIN", true)
ChangeSortKey("plaguemask", "gasmask", "SUMMER", true)

if GetModConfigData("sporehounds") then
    AddRecipe2(
        "shroom_skin",
        { Ingredient("shroom_skin_fragment", 4), Ingredient("froglegs", 2) },
        TECH.SCIENCE_TWO,
        nil,
        { "REFINE" }
    )
    ChangeSortKey("shroom_skin", "bearger_fur", "REFINE", true)
end

AddRecipe2(
    "sporepack",
    { Ingredient("shroom_skin", 1), Ingredient("rope", 2), Ingredient("spoiled_food", 2) },
    TECH.SCIENCE_TWO,
    nil,
    { "CLOTHING", "CONTAINERS" }
)
ChangeSortKey("sporepack", "icepack", "CLOTHING", true)
ChangeSortKey("sporepack", "icepack", "CONTAINERS", true)

if GetModConfigData("pocket_powertrip") ~= 0 then
    AddRecipeToFilter("raincoat", "CONTAINERS")
    ChangeSortKey("raincoat", "sporepack", "CONTAINERS", true)

    AddRecipeToFilter("reflectivevest", "CONTAINERS")
    ChangeSortKey("reflectivevest", "sporepack", "CONTAINERS", true)

    AddRecipeToFilter("hawaiianshirt", "CONTAINERS")
    ChangeSortKey("hawaiianshirt", "sporepack", "CONTAINERS", true)

    AddRecipeToFilter("trunkvest_winter", "CONTAINERS")
    ChangeSortKey("trunkvest_winter", "sporepack", "CONTAINERS", true)

    AddRecipeToFilter("trunkvest_summer", "CONTAINERS")
    ChangeSortKey("trunkvest_summer", "sporepack", "CONTAINERS", true)
end

if GetModConfigData("snowstorms") then
    AddRecipe2(
        "saltpack",
        { Ingredient("gears", 1), Ingredient("boards", 2), Ingredient("saltrock", 4) },
        TECH.SCIENCE_TWO,
        nil,
        { "TOOLS", "WINTER" }
    )
    ChangeSortKey("saltpack", "brush", "TOOLS", true)
    ChangeSortKey("saltpack", "beargervest", "WINTER", true)
end

AddRecipe2(
    "air_conditioner",
    { Ingredient("shroom_skin", 2), Ingredient("gears", 1), Ingredient("cutstone", 2) },
    TECH.SCIENCE_TWO,
    { placer = "air_conditioner_placer" },
    { "STRUCTURES" }
)
ChangeSortKey("air_conditioner", "firesuppressor", "STRUCTURES", true)

AddRecipe2(
    "skullchest_child",
    { Ingredient("fossil_piece", 2), Ingredient("nightmarefuel", 4), Ingredient("boards", 3) },
    TECH.LOST,
    { placer = "skullchest_child_placer" },
    { "STRUCTURES", "CONTAINERS", "MAGIC" }
)
ChangeSortKey("skullchest_child", "magician_chest", "STRUCTURES", true)
ChangeSortKey("skullchest_child", "magician_chest", "CONTAINERS", true)
ChangeSortKey("skullchest_child", "magician_chest", "MAGIC", true)

if GetModConfigData("hayfever_disable") then -- not in dev build since the config is commented off, but live does have it.
    AddRecipe2(
        "honey_log",
        { Ingredient("livinglog", 1), Ingredient("honey", 2) },
        TECH.NONE,
        { builder_tag = "plantkin" },
        { "CHARACTER" }
    )
    ChangeSortKey("honey_log", "livinglog", "CHARACTER", true)
end

AddRecipe2(
    "bugzapper",
    { Ingredient("spear", 1), Ingredient("transistor", 2), Ingredient("feather_canary", 2) },
    TECH.SCIENCE_TWO,
    nil,
    { "WEAPONS" }
)
ChangeSortKey("bugzapper", "nightstick", "WEAPONS", true)

AddRecipe2(
    "watermelon_lantern",
    { Ingredient("watermelon", 1), Ingredient("fireflies", 1) },
    TECH.SCIENCE_TWO,
    nil,
    { "LIGHT" }
)
ChangeSortKey("watermelon_lantern", "pumpkin_lantern", "LIGHT", true)
if GetModConfigData("rat_raids") or GetModConfigData("funny rat") then
    AddRecipe2(
        "rat_whip",
        { Ingredient("twigs", 3), Ingredient("rope", 1), Ingredient("rat_tail", 3) },
        TECH.SCIENCE_TWO,
        nil,
        { "WEAPONS" }
    )
    ChangeSortKey("rat_whip", "whip", "WEAPONS", true)
end

AddRecipe2(
    "ancient_amulet_red",
    { Ingredient("thulecite", 2), Ingredient("nightmarefuel", 3), Ingredient("redgem", 2) },
    TECH.ANCIENT_FOUR,
    { nounlock = true },
    { "CRAFTING_STATION" }
)
ChangeSortKey("ancient_amulet_red", "orangeamulet", "CRAFTING_STATION", true)

if GetModConfigData("hoodedforest") then
    AddRecipe2(
        "turf_hoodedmoss",
        { Ingredient("twigs", 1), Ingredient("greenfoliage", 4) },
        TECH.TURFCRAFTING_TWO,
        { numtogive = 4 },
        { "DECOR" }
    )
    ChangeSortKey("turf_hoodedmoss", "turf_deciduous", "DECOR", true)

    AddRecipe2(
        "turf_ancienthoodedturf",
        { Ingredient("turf_hoodedmoss", 2), Ingredient("moonrocknugget", 1) },
        TECH.TURFCRAFTING_TWO,
        { numtogive = 4 },
        { "DECOR" }
    )
    ChangeSortKey("turf_ancienthoodedturf", "turf_hoodedmoss", "DECOR", true)
end

AddRecipe2(
    "um_bear_trap_equippable_tooth",
    { Ingredient("cutstone", 2), Ingredient("houndstooth", 3), Ingredient("rope", 1) },
    TECH.SCIENCE_TWO,
    { nil },
    { "WEAPONS" }
)
ChangeSortKey("um_bear_trap_equippable_tooth", "trap_teeth", "WEAPONS", true)

AddRecipe2(
    "um_bear_trap_equippable_gold",
    { Ingredient("goldnugget", 4), Ingredient("houndstooth", 3), Ingredient("rope", 1) },
    TECH.SCIENCE_TWO,
    { nil },
    { "WEAPONS" }
)
ChangeSortKey("um_bear_trap_equippable_gold", "um_bear_trap_equippable_tooth", "WEAPONS", true)

if GetModConfigData("wiltfly") then
    AddRecipe2(
        "armor_glassmail",
        { Ingredient("glass_scales", 1), Ingredient("moonglass_charged", 10) },
        TECH.CELESTIAL_THREE,
        { nounlock = true },
        { "CRAFTING_STATION" }
    )
    ChangeSortKey("armor_glassmail", "glasscutter", "CRAFTING_STATION", true)
end

if GetModConfigData("trapdoorspiders") then
    AddRecipe2(
        "mutator_trapdoor",
        { Ingredient("monstermeat", 2), Ingredient("spidergland", 3), Ingredient("cutgrass", 5) },
        TECH.SPIDERCRAFT_ONE,
        { builder_tag = "spiderwhisperer" },
        { "CHARACTER" }
    )
    ChangeSortKey("mutator_trapdoor", "mutator_warrior", "CHARACTER", true)
end

AddRecipe2(
    "driftwoodfishingrod",
    { Ingredient("driftwood_log", 3), Ingredient("silk", 3), Ingredient("rope", 2) },
    TECH.SCIENCE_TWO,
    nil,
    { "TOOLS", "FISHING" }
)
ChangeSortKey("driftwoodfishingrod", "fishingrod", "TOOLS", true)
ChangeSortKey("driftwoodfishingrod", "fishingrod", "FISHING", true)

AddRecipe2(
    "uncompromising_fishingnet",
    { Ingredient("rope", 1), Ingredient("rocks", 2), Ingredient("silk", 3) },
    TECH.SCIENCE_ONE,
    nil,
    { "TOOLS", "FISHING" }
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
    { Ingredient("boomerang", 1), Ingredient("transistor", 2), Ingredient("steelwool", 3) },
    TECH.SCIENCE_TWO,
    nil,
    { "WEAPONS" }
)
ChangeSortKey("um_magnerang", "boomerang", "WEAPONS", true)

AddRecipe2(
    "hermitshop_rain_horn",
    { Ingredient("dormant_rain_horn", 1), Ingredient("oceanfish_small_9_inv", 3), Ingredient("messagebottleempty", 2) },
    TECH.HERMITCRABSHOP_SEVEN,
    { nounlock = true, product = "rain_horn" },
    { "CRAFTING_STATION" }
)
ChangeSortKey("hermitshop_rain_horn", "hermitshop_oceanfishingbobber_malbatross", "CRAFTING_STATION", true)

if GetModConfigData("rat_raids") then
    AddRecipe2(
        "hat_ratmask",
        { Ingredient("rope", 2), Ingredient("beardhair", 3), Ingredient("sewing_kit", 1) },
        TECH.SCIENCE_TWO,
        nil,
        { "CLOTHING" }
    )
    ChangeSortKey("hat_ratmask", "plaguemask", "CLOTHING", true)
end

AddRecipe2(
    "floral_bandage",
    { Ingredient("bandage", 1), Ingredient("cactus_flower", 2) },
    TECH.SCIENCE_TWO,
    nil,
    { "RESTORATION" }
)
ChangeSortKey("floral_bandage", "bandage", "RESTORATION", true)

AddRecipe2(
    "winona_toolbox",
    { Ingredient("boards", 2), Ingredient("goldnugget", 4), Ingredient("sewing_tape", 2) },
    TECH.NONE,
    { builder_tag = "handyperson" },
    { "CONTAINERS", "CHARACTER" }
)
ChangeSortKey("winona_toolbox", "treasurechest", "CONTAINERS", true)
ChangeSortKey("winona_toolbox", "sewing_tape", "CHARACTER", true)

AddRecipe2(
    "powercell",
    { Ingredient("sewing_tape", 1), Ingredient("goldnugget", 1), Ingredient("nitre", 2) },
    TECH.NONE,
    { builder_tag = "handyperson", numtogive = 3 },
    { "CHARACTER" }
)
ChangeSortKey("powercell", "winona_battery_high", "CHARACTER", true)

AddRecipe2(
    "winona_upgradekit_electrical",
    { Ingredient("goldnugget", 6), Ingredient("sewing_tape", 2), Ingredient("trinket_6", 2) },
    TECH.SCIENCE_TWO,
    { builder_tag = "handyperson" },
    { "CHARACTER", "LIGHT" }
)
ChangeSortKey("winona_upgradekit_electrical", "winona_toolbox", "CHARACTER", true)

AddRecipeToFilter("wardrobe", "CONTAINERS")
ChangeSortKey("wardrobe", "icebox", "CONTAINERS", false)

AddRecipeToFilter("tophat", "MAGIC")
ChangeSortKey("tophat", "armorslurper", "MAGIC", true)
if GetModConfigData("snowstorms") then
    AddRecipeToFilter("wall_hay_item", "WINTER")
    ChangeSortKey("wall_hay_item", "dragonflyfurnace", "WINTER", true)
    AddRecipeToFilter("wall_wood_item", "WINTER")
    ChangeSortKey("wall_wood_item", "wall_hay_item", "WINTER", true)
    AddRecipeToFilter("wall_stone_item", "WINTER")
    ChangeSortKey("wall_stone_item", "wall_wood_item", "WINTER", true)
    AddRecipeToFilter("wall_moonrock_item", "WINTER")
    ChangeSortKey("wall_moonrock_item", "wall_stone_item", "WINTER", true)
    AddRecipeToFilter("turf_dragonfly", "WINTER")
    ChangeSortKey("turf_dragonfly", "dragonflyfurnace", "WINTER", true)
    AddRecipeToFilter("wall_dreadstone_item", "WINTER")
    ChangeSortKey("wall_dreadstone_item", "wall_dreadstone_item", "WINTER", true)
end

AddRecipe2(
    "boatpatch_sludge",
    { Ingredient("sludge", 3), Ingredient("driftwood_log", 2) },
    TECH.NONE,
    nil, -- {numtogive = 2},
    { "SEAFARING" }
)
ChangeSortKey("boatpatch_sludge", "oar", "SEAFARING", false)

AddRecipe2(
    "sludge_sack",
    { Ingredient("sludge", 6), Ingredient("rockjawleather", 2), Ingredient("rope", 3) },
    TECH.SCIENCE_TWO,
    nil,
    { "CONTAINERS", "CLOTHING" }
)
ChangeSortKey("sludge_sack", "piggyback", "CONTAINERS", true)
ChangeSortKey("sludge_sack", "piggyback", "CLOTHING", true)

AddRecipe2(
    "boat_bumper_sludge_kit",
    { Ingredient("sludge", 4), Ingredient("driftwood_log", 2) },
    TECH.SEAFARING_ONE,
    { numtogive = 2 },
    { "SEAFARING" }
)
ChangeSortKey("boat_bumper_sludge_kit", "boat_bumper_shell_kit", "SEAFARING", true)

AddRecipe2(
    "cannonball_sludge_item",
    { Ingredient("sludge", 2), Ingredient("nitre", 1), Ingredient("charcoal", 1) },
    TECH.SEAFARING_ONE,
    { numtogive = 4 },
    { "WEAPONS", "SEAFARING" }
)
ChangeSortKey("cannonball_sludge_item", "cannonball_rock_item", "SEAFARING", true)
ChangeSortKey("cannonball_sludge_item", "cannonball_rock_item", "WEAPONS", true)

AddRecipe2(
    "sludge_oil",
    { Ingredient("sludge", 3), Ingredient("messagebottleempty", 1) },
    TECH.SCIENCE_TWO,
    nil,
    { "TOOLS", "LIGHT" }
)
ChangeSortKey("sludge_oil", "sewing_tape", "TOOLS", true)
ChangeSortKey("sludge_oil", "coldfirepit", "LIGHT", true)

AddRecipe2("armor_reed_um", { Ingredient("cutreeds", 8), Ingredient("twigs", 3) }, TECH.NONE, nil, { "ARMOUR", "RAIN" })
ChangeSortKey("armor_reed_um", "armorgrass", "ARMOUR", true)
ChangeSortKey("armor_reed_um", "raincoat", "RAIN", true)

-- ChangeSortKey("PREFAB_NAME_OF_ITEM_THAT_YOURE_SORTING","PREFAB_NAME_OF_ITEM_YOU_WANT_IT_TO_GO_AFTER","THE_TAB",true) you need to do this for each tab that you want it to be sorted in -AXE
-- need to add the inv atlases

AddRecipe2(
    "armor_sharksuit_um",
    { Ingredient("armorwood", 1), Ingredient("rockjawleather", 1), Ingredient("sludge", 4) },
    TECH.SCIENCE_TWO,
    nil,
    { "SEAFARING", "ARMOUR", "RAIN" }
)
ChangeSortKey("armor_sharksuit_um", "armordragonfly", "ARMOUR", true)
ChangeSortKey("armor_sharksuit_um", "balloonvest", "SEAFARING", true)
ChangeSortKey("armor_sharksuit_um", "armor_reed_um", "RAIN", true)

AddRecipe2(
    "brine_balm",
    { Ingredient("saltrock", 2), Ingredient("kelp", 1) }, -- , Ingredient("driftwood_log", 1)
    TECH.SCIENCE_ONE,
    nil,                                                  -- {numtogive = 2},
    { "RESTORATION" }
)
ChangeSortKey("brine_balm", "floral_bandage", "RESTORATION", true)

AddRecipe2(
    "sludge_cork",
    { Ingredient("driftwood_log", 2), Ingredient("rope", 2) },
    TECH.SCIENCE_ONE,
    nil,
    { "TOOLS", "SEAFARING" }
)
ChangeSortKey("sludge_cork", "oceanfishingrod", "TOOLS", true)
ChangeSortKey("sludge_cork", "boat_magnet_beacon", "SEAFARING", true)

--[[AddRecipe2(
    "boat_bumper_copper_kit",
    { Ingredient("um_copper_pipe", 14) },
    TECH.SEAFARING_ONE,
    { numtogive = 2 },
    { "SEAFARING" }
)
ChangeSortKey("boat_bumper_copper_kit", "boat_bumper_shell_kit", "SEAFARING", true)

AddRecipe2(
    "steeringwheel_copper_item",
    { Ingredient("um_copper_pipe", 3), Ingredient("gears", 1) },
    TECH.SEAFARING_ONE,
    nil,
    { "SEAFARING" }
)
ChangeSortKey("steeringwheel_copper_item", "steeringwheel_item", "SEAFARING", true)]]

if GetModConfigData("monstersmallmeat") then
    AddRecipe2(
        "transmute_monstermeat",
        { Ingredient("monstersmallmeat", 3) },
        TECH.NONE,
        { product = "monstermeat", builder_tag = "ick_alchemistI", description = "transmute_monstermeat" },
        { "CHARACTER" }
    )

    AddRecipe2(
        "transmute_monstersmallmeat",
        { Ingredient("monstermeat", 1) },
        TECH.NONE,
        {
            product = "monstersmallmeat",
            builder_tag = "ick_alchemistI",
            description = "transmute_monstersmallmeat",
            numtogive = 2
        },
        { "CHARACTER" }
    )

    ChangeSortKey("transmute_monstermeat", "transmute_meat", "CHARACTER", true)
    ChangeSortKey("transmute_monstersmallmeat", "transmute_smallmeat", "CHARACTER", true)
end

-- deconstruct recipes
AddDeconstructRecipe("cursed_antler", { Ingredient("boneshard", 8), Ingredient("nightmarefuel", 2) })
AddDeconstructRecipe("beargerclaw", { Ingredient("boneshard", 4), Ingredient("furtuft", 8) })
AddDeconstructRecipe("klaus_amulet", { Ingredient("goldnugget", 4), Ingredient("nightmarefuel", 6) })
AddDeconstructRecipe("feather_frock", { Ingredient("goose_feather", 6) })
AddDeconstructRecipe("gore_horn_hat", { Ingredient("meat", 2), Ingredient("nightmarefuel", 4) })
AddDeconstructRecipe("crabclaw", { Ingredient("rocks", 4), Ingredient("cutstone", 1) })
AddDeconstructRecipe("slobberlobber", { Ingredient("dragon_scales", 1), Ingredient("meat", 1) })
AddDeconstructRecipe("um_beegun", { Ingredient("honeycomb", 6), Ingredient("royal_jelly", 2) })

AddDeconstructRecipe("shadow_crown", { Ingredient("nightmarefuel", 5), Ingredient("beardhair", 3) })
AddDeconstructRecipe(
    "rain_horn",
    { Ingredient("slurtle_shellpieces", 4), Ingredient("rocks", 2), Ingredient("oceanfish_small_9_inv", 3) }
)
AddDeconstructRecipe("dormant_rain_horn", { Ingredient("cookiecuttershell", 4), Ingredient("rocks", 2) })
AddDeconstructRecipe("staff_moonfall", { Ingredient("opalpreciousgem", 3), Ingredient("slurtle_shellpieces", 5), Ingredient("livinglog", 3) })

----deconstruct recipes for craftable items
--AddDeconstructRecipe("steeringwheel_copper", { Ingredient("um_copper_pipe", 3), Ingredient("gears", 1) })

-- Sailing Rebalance related recipes.

-- trident buff
AllRecipes["trident"].ingredients = { Ingredient("boneshard", 2), Ingredient("gnarwail_horn", 1), Ingredient("twigs", 4) }

-- hermitshop expansion
AddRecipe2(
    "hermitshop_hermit_bundle_lures",
    { Ingredient("messagebottleempty", 1) },
    TECH.HERMITCRABSHOP_ONE,
    { nounlock = true, numtogive = 1, product = "hermit_bundle_lures", sg_state = "give", image = "hermit_bundle.tex" }
)
ChangeSortKey("hermitshop_hermit_bundle_lures", "hermitshop_hermit_bundle_shells", "CRAFTING_STATION", false)

AddRecipe2(
    "hermitshop_boat",
    { Ingredient("messagebottleempty", 1) },
    TECH.HERMITCRABSHOP_ONE,
    { nounlock = true, product = "boat_item", sg_state = "give" }
)
ChangeSortKey("hermitshop_boat", "hermitshop_hermit_bundle_shells", "CRAFTING_STATION", true)

AddRecipe2(
    "hermitshop_boat_rotator",
    { Ingredient("messagebottleempty", 1) },
    TECH.HERMITCRABSHOP_ONE,
    { nounlock = true, product = "boat_rotator_kit", sg_state = "give" }
)

AddRecipe2(
    "hermitshop_mast",
    { Ingredient("messagebottleempty", 1) },
    TECH.HERMITCRABSHOP_ONE,
    { nounlock = true, product = "mast_item", sg_state = "give" }
)
ChangeSortKey("hermitshop_mast", "hermitshop_boat", "CRAFTING_STATION", true)

AddRecipe2(
    "hermitshop_anchor",
    { Ingredient("messagebottleempty", 1) },
    TECH.HERMITCRABSHOP_ONE,
    { nounlock = true, product = "anchor_item", sg_state = "give" }
)
ChangeSortKey("hermitshop_anchor", "hermitshop_mast", "CRAFTING_STATION", true)

AddRecipe2(
    "hermitshop_steeringwheel",
    { Ingredient("messagebottleempty", 1) },
    TECH.HERMITCRABSHOP_ONE,
    { nounlock = true, product = "steeringwheel_item", sg_state = "give" }
)
ChangeSortKey("hermitshop_steeringwheel", "hermitshop_anchor", "CRAFTING_STATION", true)

AddRecipe2(
    "hermitshop_patch",
    { Ingredient("messagebottleempty", 1) },
    TECH.HERMITCRABSHOP_ONE,
    { nounlock = true, product = "boatpatch", sg_state = "give", numtogive = 3 }
)
ChangeSortKey("hermitshop_patch", "hermitshop_steeringwheel", "CRAFTING_STATION", true)

AddRecipe2(
    "hermitshop_blueprint",
    { Ingredient("messagebottleempty", 1) },
    GLOBAL.TECH.HERMITCRABSHOP_THREE,
    { nounlock = true, product = "blueprint", sg_state = "give" }
)
ChangeSortKey("hermitshop_blueprint", "hermitshop_turf_shellbeach_blueprint", "CRAFTING_STATION", true)

AddRecipe2(
    "hermitshop_waterplant",
    { Ingredient("messagebottleempty", 1) },
    TECH.HERMITCRABSHOP_THREE,
    { nounlock = true, product = "waterplant_planter", sg_state = "give" }
)
ChangeSortKey("hermitshop_waterplant", "hermitshop_chum", "CRAFTING_STATION", true)

AddRecipe2(
    "hermitshop_seedpacket",
    { Ingredient("messagebottleempty", 1) },
    TECH.HERMITCRABSHOP_THREE,
    { nounlock = true, product = "yotc_seedpacket", sg_state = "give", numtogive = 2 }
)
ChangeSortKey("hermitshop_seedpacket", "hermitshop_chum", "CRAFTING_STATION", true)

AddRecipe2(
    "hermitshop_seedpacket_rare",
    { Ingredient("messagebottleempty", 1) },
    TECH.HERMITCRABSHOP_FIVE,
    { nounlock = true, product = "yotc_seedpacket_rare", sg_state = "give", numtogive = 2 }
)
ChangeSortKey("hermitshop_seedpacket_rare", "hermitshop_chum", "CRAFTING_STATION", true)

AddRecipe2(
    "hermitshop_cookies",
    { Ingredient("messagebottleempty", 1) },
    TECH.HERMITCRABSHOP_SEVEN,
    { nounlock = true, product = "pumpkincookie", sg_state = "give" }
)
ChangeSortKey("hermitshop_cookies", "hermitshop_supertacklecontainer", "CRAFTING_STATION", true)

AddRecipe2(
    "normal_chum",
    { Ingredient("spoiled_food", 2), Ingredient("rope", 1), Ingredient("waterplant_bomb", 1) },
    TECH.FISHING_ONE,
    { product = "chum", nounlock = false, numtogive = 2 },
    { "FISHING" }
)
AllRecipes["chum"].ingredients = {
    Ingredient("spoiled_food", 1),
    Ingredient("rope", 1),
    Ingredient("waterplant_bomb", 1)
}
AllRecipes["hermitshop_chum"].ingredients = { Ingredient("messagebottleempty", 1) }
AllRecipes["hermitshop_chum"].numtogive = 3
--[[
AddRecipe2(
"hermitshop_oil",
{Ingredient("messagebottleempty", 3)},
TECH.HERMITCRABSHOP_FIVE,
{nounlock = true, product = "diseasecurebomb", sg_state = "give"}
)
ChangeSortKey("hermitshop_oil", "hermitshop_cookies", "CRAFTING_STATION", true)]]
-- better moonstorm
AddRecipe2(
    "moonstorm_static_item",
    { Ingredient("transistor", 1), Ingredient("moonstorm_spark", 2), Ingredient("goldnugget", 3) },
    TECH.LOST,
    nil,
    { "REFINE" }
)
AddRecipe2(
    "alterguardianhatshard",
    { Ingredient("moonglass_charged", 1), Ingredient("moonstorm_spark", 2), Ingredient("lightbulb", 1) },
    TECH.LOST,
    nil,
    { "LIGHT", "REFINE" }
)

AddDeconstructRecipe(
    "alterguardianhat",
    { Ingredient("alterguardianhatshard", 5), Ingredient("alterguardianhatshard_blueprint", 1) }
)

AddRecipe2(
    "critter_figgy_builder",
    { Ingredient("steelwool", 1), Ingredient("blueberrypancakes", 1) },
    TECH.ORPHANAGE_ONE,
    { nounlock = true, actionstr = "ORPHANAGE" }
)
ChangeSortKey("critter_figgy_builder", "critter_eyeofterror_builder", "CRAFTING_STATION", true)

AddRecipe2(
    "portableboat_item",
    { Ingredient("mosquitosack", 2), Ingredient("rope", 2) },
    TECH.SEAFARING_ONE,
    nil,
    { "SEAFARING" }
)
ChangeSortKey("portableboat_item", "boat_item", "SEAFARING", true)

AddRecipe2("codex_mantra", { Ingredient("waxwelljournal", 1) }, TECH.NONE, { builder_tag = "shadowmagic" },
    { "CHARACTER" })
ChangeSortKey("codex_mantra", "waxwelljournal", "CHARACTER", true)

AddRecipe2(
    "mastupgrade_windturbine_item",
    { Ingredient("cutstone", 2), Ingredient("transistor", 2) },
    TECH.SEAFARING_ONE,
    nil,
    { "SEAFARING" }
)
ChangeSortKey("mastupgrade_windturbine_item", "mastupgrade_lightningrod_item", "SEAFARING", true)

if GetModConfigData("ck_loot") then
    AddRecipe2(
        "hat_crab",
        { Ingredient("cutstone", 2), Ingredient("orangegem", 2), Ingredient("slurtle_shellpieces", 1) },
        TECH.LOST,
        nil,
        { "CLOTHING" }
    )

    AddRecipe2(
        "hat_crab_ice",
        { Ingredient("cutstone", 2), Ingredient("bluegem", 2), Ingredient("slurtle_shellpieces", 1) },
        TECH.LOST,
        nil,
        { "ARMOUR" }
    )

    AddRecipe2(
        "armor_crab_maxhp",
        { Ingredient("cutstone", 1), Ingredient("redgem", 3), Ingredient("slurtle_shellpieces", 3) },
        TECH.LOST,
        nil,
        { "ARMOUR" }
    )

    AddRecipe2(
        "armor_crab_regen",
        { Ingredient("cutstone", 1), Ingredient("greengem", 3), Ingredient("slurtle_shellpieces", 3) },
        TECH.LOST,
        nil,
        { "ARMOUR" }
    )

    AddRecipe2(
        "staff_starfall",
        { Ingredient("yellowgem", 3), Ingredient("slurtle_shellpieces", 5), Ingredient("livinglog", 3) },
        TECH.LOST,
        nil,
        { "WEAPONS", "SHADOWMAGIC" }
    )
    ChangeSortKey("staff_starfall", "firestaff", "WEAPONS", true)
    ChangeSortKey("staff_starfall", "firestaff", "MAGIC", true)
end

-- Pyre Nettles stuff
-- Pyre Mantle
AddRecipe2(
    "um_armor_pyre_nettles",
    { Ingredient("firenettles", 5), Ingredient("silk", 1) },
    TECH.SCIENCE_TWO,
    nil,
    { "ARMOUR", "WINTER" }
)
ChangeSortKey("um_armor_pyre_nettles", "armordragonfly", "ARMOUR", false)
ChangeSortKey("um_armor_pyre_nettles", "sweatervest", "WINTER", false)
-- Pyre Dart
AddRecipe2(
    "um_blowdart_pyre",
    { Ingredient("cutreeds", 2), Ingredient("um_smolder_spore", 1), Ingredient("firenettles", 1) },
    TECH.SCIENCE_ONE,
    nil,
    { "WEAPONS" }
)
ChangeSortKey("um_blowdart_pyre", "blowdart_fire", "WEAPONS", true)

-- Wormwood Crafts
if GetModConfigData("wormwood_trapbuffs") then
    GLOBAL.GetValidRecipe("trap_bramble").numtogive = 2
end

-- WIXIE RELATED CRAFTS
if GetModConfigData("wixie_walter") then
    AddRecipe2(
        "the_real_charles_t_horse",
        { Ingredient("nightmarefuel", 2), Ingredient("cane", 1), Ingredient("gears", 1) },
        GLOBAL.TECH.LOST,
        nil,
        { "TOOLS", "CLOTHING" }
    )

    GLOBAL.STRINGS.RECIPE_DESC.THE_REAL_CHARLES_T_HORSE = "Giddy-up, Charles!"
    AddRecipeToFilter("the_real_charles_t_horse", "TOOLS")
    AddRecipeToFilter("the_real_charles_t_horse", "CLOTHING")
    ChangeSortKey("the_real_charles_t_horse", "cane", "TOOLS", true)
    ChangeSortKey("the_real_charles_t_horse", "cane", "CLOTHING", true)

    AddRecipe2(
        "slingshot_gnasher",
        { Ingredient("livinglog", 1), Ingredient("nightmarefuel", 2), Ingredient("mosquitosack", 2) },
        GLOBAL.TECH.MAGIC_THREE,
        { builder_tag = "pebblemaker" },
        { "CHARACTER", "WEAPONS" }
    )
    GLOBAL.STRINGS.RECIPE_DESC.SLINGSHOT_GNASHER = "More bark, more bite!"
    ChangeSortKey("slingshot_gnasher", "slingshot", "WEAPONS", true)
    ChangeSortKey("slingshot_gnasher", "slingshot", "CHARACTER", true)

    AddRecipe2(
        "slingshot_matilda",
        { Ingredient("driftwood_log", 1), Ingredient("coontail", 1), Ingredient("mosquitosack", 3) },
        GLOBAL.TECH.SCIENCE_TWO,
        { builder_tag = "pebblemaker" },
        { "CHARACTER", "WEAPONS" }
    )
    GLOBAL.STRINGS.RECIPE_DESC.SLINGSHOT_MATILDA = "A whole heap of trouble!"
    ChangeSortKey("slingshot_matilda", "slingshot_gnasher", "WEAPONS", true)
    ChangeSortKey("slingshot_matilda", "slingshot_gnasher", "CHARACTER", true)

    GLOBAL.STRINGS.RECIPE_DESC.SLINGSHOT = "Cause all kinds of mischief!"

    GLOBAL.GetValidRecipe("slingshotammo_rock").numtogive = 15
    GLOBAL.GetValidRecipe("slingshotammo_gold").numtogive = 15
    GLOBAL.GetValidRecipe("slingshotammo_marble").numtogive = 15
    GLOBAL.GetValidRecipe("slingshotammo_freeze").numtogive = 15
    GLOBAL.GetValidRecipe("slingshotammo_slow").numtogive = 15

    GLOBAL.GetValidRecipe("slingshotammo_freeze").ingredients = { Ingredient("bluegem", 1) }

    GLOBAL.GetValidRecipe("slingshotammo_slow").ingredients = { Ingredient("purplegem", 1) }
    GLOBAL.STRINGS.NAMES.SLINGSHOTAMMO_SLOW = "Vortex Rounds"

    AddRecipeToFilter("slingshotammo_rock", "WEAPONS")
    AddRecipeToFilter("slingshotammo_gold", "WEAPONS")
    AddRecipeToFilter("slingshotammo_marble", "WEAPONS")
    AddRecipeToFilter("slingshotammo_poop", "WEAPONS")
    AddRecipeToFilter("slingshotammo_freeze", "WEAPONS")
    AddRecipeToFilter("slingshotammo_slow", "WEAPONS")
    AddRecipeToFilter("slingshotammo_thulecite", "WEAPONS")
    AddRecipeToFilter("slingshotammo_thulecite", "CRAFTING_STATION")
    AddRecipeToFilter("slingshotammo_shadow", "WEAPONS")

    ChangeSortKey("slingshotammo_rock", "slingshot_matilda", "WEAPONS", true)
    ChangeSortKey("slingshotammo_rock", "slingshot_matilda", "CHARACTER", true)

    ChangeSortKey("slingshotammo_gold", "slingshotammo_rock", "WEAPONS", true)
    ChangeSortKey("slingshotammo_gold", "slingshotammo_rock", "CHARACTER", true)

    ChangeSortKey("slingshotammo_marble", "slingshotammo_gold", "WEAPONS", true)
    ChangeSortKey("slingshotammo_marble", "slingshotammo_gold", "CHARACTER", true)

    ChangeSortKey("slingshotammo_poop", "slingshotammo_marble", "WEAPONS", true)
    ChangeSortKey("slingshotammo_poop", "slingshotammo_marble", "CHARACTER", true)

    ChangeSortKey("slingshotammo_freeze", "slingshotammo_poop", "WEAPONS", true)
    ChangeSortKey("slingshotammo_freeze", "slingshotammo_poop", "CHARACTER", true)

    ChangeSortKey("slingshotammo_slow", "slingshotammo_freeze", "WEAPONS", true)
    ChangeSortKey("slingshotammo_slow", "slingshotammo_freeze", "CHARACTER", true)

    ChangeSortKey("slingshotammo_thulecite", "slingshotammo_slow", "WEAPONS", true)
    ChangeSortKey("slingshotammo_thulecite", "slingshotammo_slow", "CHARACTER", true)
    ChangeSortKey("slingshotammo_thulecite", "ruins_bat", "CRAFTING_STATION", true)

    AddRecipe2(
        "slingshotammo_lazy",
        { Ingredient("orangegem", 1), Ingredient("nightmarefuel", 1) },
        GLOBAL.TECH.ANCIENT_TWO,
        { builder_tag = "pebblemaker", numtogive = 20, no_deconstruction = true, nounlock = true },
        { "CHARACTER", "WEAPONS", "CRAFTING_STATION" }
    )
    GLOBAL.STRINGS.RECIPE_DESC.SLINGSHOTAMMO_LAZY = "Now you see me..."
    ChangeSortKey("slingshotammo_lazy", "slingshotammo_thulecite", "WEAPONS", true)
    ChangeSortKey("slingshotammo_lazy", "slingshotammo_thulecite", "CHARACTER", true)
    ChangeSortKey("slingshotammo_lazy", "slingshotammo_thulecite", "CRAFTING_STATION", true)

    AddRecipe2(
        "slingshotammo_shadow",
        { Ingredient("nightmarefuel", 1) },
        GLOBAL.TECH.LOST,
        { builder_tag = "pebblemaker", numtogive = 10, no_deconstruction = true },
        { "CHARACTER", "WEAPONS" }
    )
    GLOBAL.STRINGS.RECIPE_DESC.SLINGSHOTAMMO_SHADOW = "Spread the terror."
    ChangeSortKey("slingshotammo_shadow", "slingshotammo_lazy", "WEAPONS", true)
    ChangeSortKey("slingshotammo_shadow", "slingshotammo_lazy", "CHARACTER", true)

    AddRecipe2(
        "slingshotammo_firecrackers",
        { Ingredient("nitre", 1) },
        GLOBAL.TECH.SCIENCE_TWO,
        { builder_tag = "pebblemaker", numtogive = 15, no_deconstruction = true },
        { "CHARACTER", "WEAPONS" }
    )
    GLOBAL.STRINGS.RECIPE_DESC.SLINGSHOTAMMO_FIRECRACKERS = "For the aspiring young menace."
    ChangeSortKey("slingshotammo_firecrackers", "slingshotammo_lazy", "WEAPONS", true)
    ChangeSortKey("slingshotammo_firecrackers", "slingshotammo_lazy", "CHARACTER", true)

    AddRecipe2(
        "slingshotammo_honey",
        { Ingredient("honey", 3) },
        GLOBAL.TECH.SCIENCE_TWO,
        { builder_tag = "pebblemaker", numtogive = 10, no_deconstruction = true },
        { "CHARACTER", "WEAPONS" }
    )
    GLOBAL.STRINGS.RECIPE_DESC.SLINGSHOTAMMO_HONEY = "Oh bother!"
    ChangeSortKey("slingshotammo_honey", "slingshotammo_firecrackers", "WEAPONS", true)
    ChangeSortKey("slingshotammo_honey", "slingshotammo_firecrackers", "CHARACTER", true)

    AddRecipe2(
        "slingshotammo_rubber",
        { Ingredient("mosquitosack", 1) },
        GLOBAL.TECH.SCIENCE_ONE,
        { builder_tag = "pebblemaker", numtogive = 15, no_deconstruction = true },
        { "CHARACTER", "WEAPONS" }
    )
    GLOBAL.STRINGS.RECIPE_DESC.SLINGSHOTAMMO_RUBBER = "Rebounding Rounds."
    ChangeSortKey("slingshotammo_rubber", "slingshotammo_honey", "WEAPONS", true)
    ChangeSortKey("slingshotammo_rubber", "slingshotammo_honey", "CHARACTER", true)

    AddRecipe2(
        "slingshotammo_tremor",
        { Ingredient("townportaltalisman", 1) },
        GLOBAL.TECH.SCIENCE_TWO,
        { builder_tag = "pebblemaker", numtogive = 10, no_deconstruction = true },
        { "CHARACTER", "WEAPONS" }
    )
    GLOBAL.STRINGS.RECIPE_DESC.SLINGSHOTAMMO_TREMOR = "See what shakes loose."
    ChangeSortKey("slingshotammo_tremor", "slingshotammo_rubber", "WEAPONS", true)
    ChangeSortKey("slingshotammo_tremor", "slingshotammo_rubber", "CHARACTER", true)

    AddRecipe2(
        "slingshotammo_moonrock",
        { Ingredient("moonrocknugget", 1) },
        GLOBAL.TECH.SCIENCE_TWO,
        { builder_tag = "pebblemaker", numtogive = 15, no_deconstruction = true },
        { "CHARACTER", "WEAPONS" }
    )
    GLOBAL.STRINGS.RECIPE_DESC.SLINGSHOTAMMO_MOONROCK = "Take the fight to the next dimension."
    ChangeSortKey("slingshotammo_moonrock", "slingshotammo_tremor", "WEAPONS", true)
    ChangeSortKey("slingshotammo_moonrock", "slingshotammo_tremor", "CHARACTER", true)

    AddRecipe2(
        "slingshotammo_moonglass",
        { Ingredient("moonglass", 1) },
        GLOBAL.TECH.CELESTIAL_THREE,
        { builder_tag = "pebblemaker", numtogive = 10, no_deconstruction = true, nounlock = true },
        { "CHARACTER", "WEAPONS" }
    )
    GLOBAL.STRINGS.RECIPE_DESC.SLINGSHOTAMMO_MOONGLASS = "Watch your hands!"
    ChangeSortKey("slingshotammo_moonglass", "slingshotammo_moonrock", "WEAPONS", true)
    ChangeSortKey("slingshotammo_moonglass", "slingshotammo_moonrock", "CHARACTER", true)
    ChangeSortKey("slingshotammo_moonglass", "glasscutter", "CRAFTING_STATION", true)

    AddRecipe2(
        "slingshotammo_salt",
        { Ingredient("saltrock", 1) },
        GLOBAL.TECH.SCIENCE_TWO,
        { builder_tag = "pebblemaker", numtogive = 15, no_deconstruction = true },
        { "CHARACTER", "WEAPONS" }
    )
    GLOBAL.STRINGS.RECIPE_DESC.SLINGSHOTAMMO_SALT = "Salt in the wounds!"
    ChangeSortKey("slingshotammo_salt", "slingshotammo_moonglass", "WEAPONS", true)
    ChangeSortKey("slingshotammo_salt", "slingshotammo_moonglass", "CHARACTER", true)

    AddRecipe2(
        "slingshotammo_slime",
        { Ingredient("slurtleslime", 1), Ingredient("rocks", 1) },
        GLOBAL.TECH.SCIENCE_TWO,
        { builder_tag = "pebblemaker", numtogive = 10, no_deconstruction = true },
        { "CHARACTER", "WEAPONS" }
    )
    GLOBAL.STRINGS.RECIPE_DESC.SLINGSHOTAMMO_SLIME = "It's slime time!"
    ChangeSortKey("slingshotammo_slime", "slingshotammo_salt", "CHARACTER", true)
    ChangeSortKey("slingshotammo_slime", "slingshotammo_salt", "WEAPONS", true)

    AddRecipe2(
        "slingshotammo_goop",
        { Ingredient("glommerfuel", 1) },
        GLOBAL.TECH.SCIENCE_TWO,
        { builder_tag = "pebblemaker", numtogive = 5, no_deconstruction = true },
        { "CHARACTER", "WEAPONS" }
    )
    GLOBAL.STRINGS.RECIPE_DESC.SLINGSHOTAMMO_GOOP = "Goop for you, goop for me!"
    ChangeSortKey("slingshotammo_goop", "slingshotammo_slime", "CHARACTER", true)
    ChangeSortKey("slingshotammo_goop", "slingshotammo_slime", "WEAPONS", true)

    AddRecipe2(
        "slingshotammo_tar",
        { Ingredient("placeholder_ingredient_ia_um", 0) },
        GLOBAL.TECH.SCIENCE_TWO,
        { builder_tag = "pebblemaker", numtogive = 10, no_deconstruction = true },
        { "CHARACTER", "WEAPONS" }
    )

    GLOBAL.STRINGS.RECIPE_DESC.SLINGSHOTAMMO_TAR = "Sticky trails!"
    ChangeSortKey("slingshotammo_tar", "slingshotammo_goop", "WEAPONS", true)
    ChangeSortKey("slingshotammo_tar", "slingshotammo_goop", "CHARACTER", true)

    AddRecipe2(
        "slingshotammo_obsidian",
        { Ingredient("placeholder_ingredient_ia", 0) },
        GLOBAL.TECH.OBSIDIAN_TWO,
        { builder_tag = "pebblemaker", numtogive = 10, no_deconstruction = true, nounlock = true },
        { "CRAFTING_STATION", "CHARACTER", "WEAPONS" }
    )

    GLOBAL.STRINGS.RECIPE_DESC.SLINGSHOTAMMO_OBSIDIAN = "A playful bit of arson."
    ChangeSortKey("slingshotammo_obsidian", "armorobsidian", "CRAFTING_STATION", true)
    ChangeSortKey("slingshotammo_obsidian", "slingshotammo_tar", "CHARACTER", true)
    ChangeSortKey("slingshotammo_obsidian", "slingshotammo_tar", "WEAPONS", true)

    AddRecipe2(
        "bagofmarbles",
        { Ingredient("slingshotammo_marble", 10), Ingredient("rope", 1) },
        GLOBAL.TECH.SCIENCE_TWO,
        { builder_tag = "pebblemaker" },
        { "CHARACTER", "WEAPONS" }
    )
    GLOBAL.STRINGS.RECIPE_DESC.BAGOFMARBLES = "Watch your step!"
    ChangeSortKey("bagofmarbles", "slingshotammo_salt", "WEAPONS", true)
    ChangeSortKey("bagofmarbles", "slingshotammo_salt", "CHARACTER", true)

    AddRecipe2(
        "meatrack_hat",
        { Ingredient("twigs", 2), Ingredient("rope", 1), Ingredient("charcoal", 1) },
        GLOBAL.TECH.NONE,
        { builder_tag = "pinetreepioneer" },
        { "CHARACTER", "COOKING", "CLOTHING" }
    )
    GLOBAL.STRINGS.RECIPE_DESC.MEATRACK_HAT = "The jerkiest of hats."
    ChangeSortKey("meatrack_hat", "walterhat", "CLOTHING", true)
    ChangeSortKey("meatrack_hat", "walterhat", "CHARACTER", true)

    STRINGS.CHARACTERS.GENERIC.DESCRIBE.WIXIEGUN = "Shhh, don't spoil it! ;)"

    AddPrefabPostInit("forest", function(inst)
        inst:DoTaskInTime(0, function(inst)
            if Prefabs["obsidian"] then
                AllRecipes["slingshotammo_obsidian"].ingredients = { Ingredient("obsidian", 1) }
            end
        end)
    end)
end

--recipe postinits
AddPrefabPostInit("forest", function(inst)
    AddRecipePostInitAny(function(recipe)
        if recipe.FindAndConvertIngredient ~= nil then
            local tar = recipe:FindAndConvertIngredient("tar")             -- tar/sludge can replace eachother!
            local sludge = recipe:FindAndConvertIngredient("sludge")
            local shark_fin = recipe:FindAndConvertIngredient("shark_fin") -- shark fins/rockjaw leather can replace eachother!
            local rockjawleather = recipe:FindAndConvertIngredient("rockjawleather")
            local mosquitosack = recipe:FindAndConvertIngredient("mosquitosack")

            if tar and tar.AddDictionaryPrefab ~= nil then
                tar:AddDictionaryPrefab("sludge")
            end

            if sludge and sludge.AddDictionaryPrefab ~= nil then
                if GLOBAL.Prefabs["tar"] ~= nil then
                    sludge:AddDictionaryPrefab("tar")
                end
            end

            if sludge and sludge.AddDictionaryPrefab ~= nil and GLOBAL.Prefabs["tar"] ~= nil then
                sludge:AddDictionaryPrefab("tar")
            end

            if shark_fin and shark_fin.AddDictionaryPrefab ~= nil then
                shark_fin:AddDictionaryPrefab("rockjawleather")
            end

            if rockjawleather and rockjawleather.AddDictionaryPrefab ~= nil and GLOBAL.Prefabs["shark_fin"] ~= nil then
                rockjawleather:AddDictionaryPrefab("shark_fin")
            end

            if mosquitosack and mosquitosack.AddDictionaryPrefab ~= nil and GLOBAL.Prefabs["mosquitosack_yellow"] then
                mosquitosack:AddDictionaryPrefab("mosquitosack_yellow")
            end
        end
    end)

    AddRecipePostInit("slingshot_matilda", function(recipe)
        if recipe.FindAndConvertIngredient ~= nil then
            local coontail = recipe:FindAndConvertIngredient("coontail")
            if coontail and coontail.AddDictionaryPrefab ~= nil and GLOBAL.Prefabs["vine"] ~= nil then
                coontail:AddDictionaryPrefab("vine")
            end

            local driftwood_log = recipe:FindAndConvertIngredient("driftwood_log")
            if driftwood_log and driftwood_log.AddDictionaryPrefab ~= nil and GLOBAL.Prefabs["ox_horn"] ~= nil then
                driftwood_log:AddDictionaryPrefab("ox_horn")
            end
        end
    end)

    AddRecipePostInit("brine_balm", function(recipe)
        if recipe.FindAndConvertIngredient ~= nil then
            local kelp = recipe:FindAndConvertIngredient("kelp")
            if kelp and kelp.AddDictionaryPrefab ~= nil and GLOBAL.Prefabs["seaweed"] ~= nil then
                kelp:AddDictionaryPrefab("seaweed")
            end
        end
    end)

    AddRecipePostInit("sludge_oil", function(recipe)
        if recipe.FindAndConvertIngredient ~= nil then
            local bottle = recipe:FindAndConvertIngredient("messagebottleempty")
            if bottle and bottle.AddDictionaryPrefab ~= nil and GLOBAL.Prefabs["ia_messagebottleempty"] ~= nil then
                bottle:AddDictionaryPrefab("ia_messagebottleempty")
            end
        end
    end)

    AddRecipePostInit("gasmask", function(recipe)
        if recipe.FindAndConvertIngredient ~= nil then
            local feather = recipe:FindAndConvertIngredient("goose_feather")
            if feather and feather.AddDictionaryPrefab ~= nil and GLOBAL.Prefabs["doydoyfeather"] ~= nil then
                feather:AddDictionaryPrefab("doydoyfeather")
            end
        end
    end)
end)



STRINGS.UI.CRAFTING.NEEDSTECH.BOMBMIXER = "Put an explosive on the Bomb Mixer to start mixing!"
STRINGS.ACTIONS.OPEN_CRAFTING.BOMBMIXER = "Mix at"

STRINGS.RECIPE_DESC.TRANSMUTE_MONSTERMEAT = "Transmute Monster Morsels into Monster Meat"
STRINGS.RECIPE_DESC.TRANSMUTE_MONSTERSMALLMEAT = "Transmute Monster Morsels into Monster Meat"

STRINGS.RECIPE_DESC.WATERMELON_LANTERN = "Juicy illumination."
STRINGS.RECIPE_DESC.CRITTERLAB_REAL = "Cute pals to ruin the mood."
STRINGS.RECIPE_DESC.UM_SAND = "Turn a big rock into smaller rocks."
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
STRINGS.RECIPE_DESC.STEERINGWHEEL_COPPER_ITEM = "Steer more than your masts."
STRINGS.RECIPE_DESC.TRINKET_6 = "A key ingredient for modern marvels."
STRINGS.RECIPE_DESC.PORTABLEBOAT_ITEM = "Pack up and go!"
STRINGS.RECIPE_DESC.MASTUPGRADE_WINDTURBINE_ITEM = "Full speed ahead!"
STRINGS.RECIPE_DESC.CODEX_MANTRA = "Repeat after me."
if GetModConfigData("telestaff_rework") then
    STRINGS.RECIPE_DESC.TELEBASE = "Now with 100% less gold!"
end
-- sailing rebalance strings
STRINGS.RECIPE_DESC.MOONSTORM_STATIC_ITEM = "The power of the moon, contained!"
STRINGS.RECIPE_DESC.ALTERGUARDIANHATSHARD = "Harness the moonlight."
STRINGS.RECIPE_DESC.WATERPLANT_PLANTER = "Grow your very own Sea Weed."
STRINGS.RECIPE_DESC.BLUEPRINT = "Learn new things."
STRINGS.RECIPE_DESC.PUMPKINCOOKIE = "Grandma's cookies."
STRINGS.RECIPE_DESC.HERMIT_BUNDLE_LURES = "Get to fishing, today!"
-- Pyre Nettle stuff
STRINGS.RECIPE_DESC.UM_ARMOR_PYRE_NETTLES = "Hurts you a little, hurts them a lot."
STRINGS.RECIPE_DESC.UM_BLOWDART_PYRE = "Warm and fuzzy, inside AND out!"

STRINGS.RECIPE_DESC.WINONA_CATAPULT_ITEM = STRINGS.RECIPE_DESC.WINONA_CATAPULT
STRINGS.RECIPE_DESC.WINONA_SPOTLIGHT_ITEM = STRINGS.RECIPE_DESC.WINONA_SPOTLIGHT
STRINGS.RECIPE_DESC.WINONA_BATTERY_LOW_ITEM = STRINGS.RECIPE_DESC.WINONA_BATTERY_LOW
STRINGS.RECIPE_DESC.WINONA_BATTERY_HIGH_ITEM = STRINGS.RECIPE_DESC.WINONA_BATTERY_HIGH

-- [ PROTOTYPERS ] --
GLOBAL.PROTOTYPER_DEFS.critterlab_real = GLOBAL.PROTOTYPER_DEFS.critterlab

AddPrototyperDef(
    "um_bombmixer",
    {
        icon_atlas = GLOBAL.CRAFTING_ICONS_ATLAS,
        icon_image = "station_madscience_lab.tex",
        is_crafting_station = true,
        action_str = "BOMBMIXER",
        filter_text = STRINGS.UI.CRAFTING_STATION_FILTERS.MADSCIENCE
    }
)
