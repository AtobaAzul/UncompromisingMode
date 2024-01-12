-- Update this list when adding files
local component_post = {
    "groundpounder",
    "propagator",
    "moisture",
    "weapon",
    --	"hunter",
    "kramped",
    "explosiveresist",
    "crop",
    --	"beargerspawner",
    "workable",
    "sleepingbaguser",
    "hounded",
    "sleeper",
    "fueled",
    "perishable",
    --	"carnivalevent",
    "lootdropper",
    "ambientsound",
    "foodaffinity",
    "eater",
    "edible",
    "inventory", -- This is an attempt at manually fixing an issue when people are checked for insulation. -scrimbles
    "weighable",
    "messagebottlemanager",
    "fishingnet",
    "boatleak", -- for custom boat patches.
    "wisecracker",
    "boatphysics",
    "map",
    "playerspawner",
    --	"drownable",
    "combat",
    "combat_replica",
    "hullhealth",
    "health",
    --	"spellbook"
    "finiteuses",
    "piratespawner",
    "repairable",
    "sewing",
    "container",
    "weather",
    "worldtemperature",
    "worldwind",
    "planarentity",
    "geyserfx",
    "firedetector",
    "slipperyfeet",
    "walkableplatformplayer",
}

local prefab_post = {
    "atrium_gate",
    "dragonfly",
    "wardrobe",
    "shieldofcthulu",
    "clockworks",
    "flingobalance",
    --	"chester",
    "mushlight",
    --	"toadstool_cap", Moved to init_uncompromising_mod.lua
    "amulet",
    "cave_entrance_open",
    "catcoon",
    "icehound",
    "firehound",
    "fishmeats", -- fish meat now dries into fish jerky
    "forest",
    "cave",
    "world",
    "antlion",
    "minifan",
    "spider",
    "hound",
    "ash",
    "bunnyman",
    "walls",
    "infestables",
    "foodbuffs",
    "mutatedhound",
    "skeleton",
    --	"shadowcreature",
    "berrybush",
    --	"papyrus",
    "sporecloud",
    "featherhat",
    --	"malbatross",
    "mushrooms",
    "rock_ice",
    "toadstool",
    "oasislake",
    --	"shadowcreature",
    "lureplant",
    "spiderden",
    "stafflights",
    "armor_ruins",
    "sweatervest",
    "fans",
    "skeletonhat",
    --	"rock_avocado_fruit_sprout_sapling",
    "icepack",
    "heatrock",
    "dragonfly_spawner",
    "rneghostfire",
    "monkey",
    "batcave",
    "rain",
    "molehat",
    "mosquito",
    "armor_bramble",
    --	"woby",
    "cave_network",
    "glasscutter",
    "critterlab",
    "wobster",
    "trinkets", -- This is for the grave mound cc trinkets
    "trap",     -- prevents traps and rabbits from 'sleeping' off screen
    "moonbase",
    "koalas",
    "pumpkin_lantern",
    "piggyback",
    "nightlight",
    "armor_sanity",
    "tophat",
    "tophatreduction",
    "ruinsstatues",
    "moondial",
    --	"deciduoustrees",
    "pktrades",
    "pigking",
    "marblebean",
    "reviver",
    --	"bundle",
    "eyebrella",
    "birds",
    "tonichandlers",
    "houndwarning",
    --	"carnival_host",
    "spider_whistle",
    "spider_healer",
    "siestahut",
    "bedroll_furry",
    "bees",
    "beemine",
    "farmplants",
    "rainhat",
    "darts",
    "terrarium",
    "bandage",
    "grassgekko",
    "minotaur_drops",
    "frog",
    "klaus",
    "klaus_sack",
    "krampus",
    "krampus_sack",
    "waterplant",
    --	"grassgator",
    "alterguardian",
    "seasonal_shoals",
    "petals",
    "lantern",
    "minerhat",
    "shark",
    "fertilizer",
    "stinger",
    "boat_pirate",
    "trident", -- for giving the leak a cause.
    "boat_bumpers",
    "slurtle_shellpieces",
    "sludge_fueled",
    -- "nightsword",
    "bigshadowtentacle",
    "mast",
    "multitool_axe_pickaxe",
    "staffs", -- generic staffs.
    "stalker",
    "sacred_chest",
    "vetcurse_drops",
    "mermhat",
    "wptags",
    "inventoryitem_classified",
    "cannonballs",
    --	"renameable_items",
    "lightninggoatherd",
    "archive_centipede",
    "firenettles",
    "staff_tornado",
    "rainometer",
    "winterometer",
    "mooneye",
    "dragoonegg",
    "bomb_lunarplant",
    "compostingbin",
    "plantables",
}

local stategraph_post = {
    "wilson",
    "wilson_client",
    "spider",
    "frog",
    --	"wobysmall",
    --	"shadowcreature",
    "stalker_minion",
    --	"merm",
    "carnival_host",
    "catcoon",
    "powdermonkey"
}

local class_post = {
    "components/inventoryitem_replica",
    --	"screens/playerhud",
    "widgets/itemtile",
    --	"widgets/hoverer",
    "widgets/moisturemeter",
    "widgets/controls",
    "widgets/craftslot",
    "widgets/bloodover"
}

local brain_post = {
    --	"hound",
    "frog",
    "krampus",
    "nofirepanic",
    "chester",
    "mossling",
    "perd",
    "catcoon",
    "deer",
    "shadowwaxwell",
    "terrorguisestuff",
}

if GetModConfigData("wixie_walter") then
    local wixie_prefabs = {
        "extra_claustrophobia_checks", -- extra tag that wixie checks when registering claustrophobia, for stuff like jackolanterns and ruins relics
        "slingshot",                   -- stuff for new slingshot aiming and wixie exclusivity
        "walter",                      -- all of walters things, including woby action
        "wobysmall",
        "wobybig",
        "wormhole",      -- wixie loses more sanity from wormholes
        "slingshotammo", -- removes hunger value from slingshot ammo, preventing slurtle feeding strats
        "coconut",       -- shoot a coconut
		"sculptingtable" -- Sculpting table crashes if picker inventory is nil
    }
    local wixie_components = {
        "healer",         -- Walter gets a 50% bonus from healing items, over time. works on companions too.
        "bufferedaction", -- This handles wixie sending an rpc with the mouse pointer click location
        "wobypicking",    -- This reroutes the pickup action and pickable component to add items to wobys container instead of a nil inventory
        "dryer"           -- This reroutes the dryer harvest action to add items to a container instead of a nil inventory

    }

    for k, v in ipairs(wixie_prefabs) do
        modimport("wixie_postinit/prefabs/" .. v)
    end

    for k, v in ipairs(wixie_components) do
        modimport("wixie_postinit/components/" .. v)
    end

    modimport("wixie_postinit/walter_actions")
    modimport("wixie_postinit/widgets/controls") -- Claustrophobia overlay init

    modimport("wixie_postinit/stategraphs/SGwixie")
    modimport("wixie_postinit/stategraphs/SGwixie_client")
    modimport("wixie_postinit/stategraphs/SGwobysmall")

    modimport("wixie_postinit/walter_strings")
    modimport("wixie_postinit/wixie_strings")
    modimport("wixie_postinit/wixie_shipwrecked")

    RemapSoundEvent("dontstarve/characters/wixie/death_voice", "wixie/characters/wixie/death_voice")
    RemapSoundEvent("dontstarve/characters/wixie/hurt", "wixie/characters/wixie/hurt")
    RemapSoundEvent("dontstarve/characters/wixie/talk_LP", "wixie/characters/wixie/talk_LP")
    RemapSoundEvent("dontstarve/characters/wixie/ghost_LP", "wixie/characters/wixie/ghost_LP")
    RemapSoundEvent("dontstarve/characters/wixie/nightmare_LP", "wixie/characters/wixie/nightmare_LP")
    RemapSoundEvent("dontstarve/characters/wixie/yawn", "wixie/characters/wixie/yawn")
    RemapSoundEvent("dontstarve/characters/wixie/emote", "wixie/characters/wixie/emote")
    RemapSoundEvent("dontstarve/characters/wixie/pose", "wixie/characters/wixie/pose")
    RemapSoundEvent("dontstarve/characters/wixie/yawn", "wixie/characters/wixie/yawn")
    RemapSoundEvent("dontstarve/characters/wixie/eye_rub_vo", "wixie/characters/wixie/eye_rub_vo")
    RemapSoundEvent("dontstarve/characters/wixie/carol", "wixie/characters/wixie/carol")
    RemapSoundEvent("dontstarve/characters/wixie/sinking", "wixie/characters/wixie/sinking")
end

if GetModConfigData("hangyperds") then
    table.insert(stategraph_post, "perd")
    table.insert(brain_post, "perdhungry")
    table.insert(prefab_post, "perd")
end

if GetModConfigData("harder_deerclops") then
    table.insert(stategraph_post, "deerclops")
    table.insert(prefab_post, "deerclops")
end

if GetModConfigData("harder_moose") then
    table.insert(stategraph_post, "moose")
    table.insert(prefab_post, "moose")
    table.insert(brain_post, "moose")
end

if GetModConfigData("harder_bearger") then
    table.insert(stategraph_post, "bearger")
    table.insert(prefab_post, "bearger")
    table.insert(brain_post, "bearger")
end

if GetModConfigData("harder_leifs") then
    table.insert(stategraph_post, "Leif")
    table.insert(prefab_post, "leif")
    table.insert(prefab_post, "leif_sparse")
    table.insert(brain_post, "leif")
end

if GetModConfigData("rework_minotaur") then
    table.insert(stategraph_post, "minotaur")
    table.insert(prefab_post, "minotaur")
    table.insert(prefab_post, "pillar_ruins")
end

if GetModConfigData("harder_lavae") then
    table.insert(prefab_post, "lavae")
end

if GetModConfigData("pinelings") then
    table.insert(prefab_post, "evergreen_stump")
end

if GetModConfigData("canedurability") then
    table.insert(prefab_post, "cane")
end

if GetModConfigData("angrypenguins") then
    table.insert(prefab_post, "penguin")
    table.insert(prefab_post, "penguin_ice") -- I think that should go too?  idk right here
end

if GetModConfigData("harder_pigs") then
    table.insert(prefab_post, "pigman")
    table.insert(brain_post, "pig")
    table.insert(stategraph_post, "pigbunny")
end

if GetModConfigData("angry_werepigs") then
    table.insert(brain_post, "werepig")
end

if GetModConfigData("harder_walrus") then
    table.insert(prefab_post, "walrus")
    table.insert(stategraph_post, "walrus")
end
if GetModConfigData("harder_beefalo") then
    table.insert(stategraph_post, "Beefalo")
end

if GetModConfigData("harder_spider_queen") then
    table.insert(prefab_post, "spiderqueen")
    table.insert(stategraph_post, "spiderqueen")
end

if GetModConfigData("pocket_powertrip") ~= 0 then
    table.insert(prefab_post, "pocket_powertrip")
end

if GetModConfigData("harder_koalefants") then
    table.insert(stategraph_post, "koalefant")
end

if GetModConfigData("reworked_eyes") then
    table.insert(prefab_post, "eyeofterror")
    table.insert(stategraph_post, "eyeofterror")
end

if GetModConfigData("scalemailbuff") then
    table.insert(prefab_post, "armor_dragonfly")
end

if (not GLOBAL:TestForIA() or GetModConfigData("um_music", true)) then
    table.insert(component_post, "dynamicmusic")
end

if GetModConfigData("winter_burning") and not TUNING.DSTU.ISLAND_ADVENTURES then
    table.insert(component_post, "burnable")
end

if GetModConfigData("amalgams") then
    table.insert(prefab_post, "chessjunk")
end
--[[
if GetModConfigData("moon_transformations") then
	table.insert(prefab_post, "flower")
end
]]
if GetModConfigData("electricalmishap_") ~= 0 then
    table.insert(prefab_post, "nightstick")
end

if GetModConfigData("fiendforcedmetodothis") then
    table.insert(prefab_post, "snurtle")
end

if GetModConfigData("harder_krampus") then
    table.insert(stategraph_post, "krampus")
end

if GetModConfigData("noauradamage_butterfly") then
    table.insert(prefab_post, "butterfly")
end

if GetModConfigData("beefalo_nerf") then
    table.insert(component_post, "rider")
end

if GetModConfigData("harder_beequeen") then
    table.insert(prefab_post, "beequeen")
    table.insert(prefab_post, "beeguard")

    table.insert(stategraph_post, "beequeen")
    table.insert(stategraph_post, "beeguard")

    table.insert(brain_post, "beequeen")
end

-- if GetModConfigData("boatturning") then
--	table.insert(prefab_post, "boat")
-- end

if GetModConfigData("winona_portables_") then
    table.insert(prefab_post, "winona_portables")
end

if GetModConfigData("reworked_ck") then
    table.insert(prefab_post, "crabking")
    table.insert(prefab_post, "crabking_claw")
    table.insert(stategraph_post, "crabkingclaw")
    table.insert(stategraph_post, "crabking")
end

table.insert(prefab_post, "shadowchesspieces") --changes to  all 3 pieces. (no collision and shadowcrown loot)

if GetModConfigData("changed_shadow_pieces") then
    --table.insert(prefab_post, "shadow_knight")
    table.insert(stategraph_post, "shadow_bishop")
    --table.insert(stategraph_post, "shadow_knight")
end

if GetModConfigData("hambatnerf") then
    table.insert(prefab_post, "hambat")
end

if GetModConfigData("mermtweaks") then
    table.insert(prefab_post, "mermhouse")
end

if GetModConfigData("townportal_rework") then
    table.insert(prefab_post, "townportal")
end

if GetModConfigData("monstersmallmeat") then
    table.insert(prefab_post, "bat")
end

if GetModConfigData("cookiecutterhat") then
    table.insert(prefab_post, "cookiecutterhat")
end

if GetModConfigData("boss_resistance_") ~= false then
    modimport("postinit/boss_resistance")
end

if GetModConfigData("heatwaves") then
    table.insert(component_post, "wildfires")
end

if GetModConfigData("lifeinjector_rework") then
    table.insert(prefab_post, "lifeinjector")
end

if GetModConfigData("sharpshooter_monkeys") then
    table.insert(brain_post, "powdermonkey")
end

modimport("postinit/sim")
modimport("postinit/any")
modimport("postinit/player")

for _, v in pairs(component_post) do
    modimport("postinit/components/" .. v)
end

for _, v in pairs(prefab_post) do
    modimport("postinit/prefabs/" .. v)
end

for _, v in pairs(stategraph_post) do
    modimport("postinit/stategraphs/SG" .. v)
end

for _, v in pairs(brain_post) do
    modimport("postinit/brains/" .. v .. "brain")
end

for _, v in pairs(class_post) do
    -- These contain a path already, e.g. v= "widgets/inventorybar"
    modimport("postinit/" .. v)
end
