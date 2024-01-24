name = "󰀕 Uncompromising Mode"
-- borrowed from IA
folder_name = folder_name or "workshop-"
if not folder_name:find("workshop-") then
    name = "[LOCAL] - " .. name
end
local _version = "1.4.10.0"
description = [[
󰀔 [ Version: ]].._version..[[ - "Under the Weather Pt.1" ]

Uncompromising Mode increases the risk and reward for those who have mastered Don't Starve Together.

Latest update features:
- New spring weather, uncluding storms, tornados, and cave flooding.
- Alpha Goats will appear in goat herds, to protect their own, and have consistant loot.
- Krampii will more effectively steal things and do their job.
- A ton of misc. changes, ranging from Wickerbottom's books to hounds.

󰀏 NEXT UPDATE: ?????? ???? ??? ????]]

author = "󰀈 The Uncomp Dev Team 󰀈"

--RELEASE.MAJOR.MINOR.FIX
version = "Under the Weather Pt.1 v".._version


forumthread = "/topic/111892-announcement-uncompromising-mode/"

api_version = 10

dst_compatible = true
dont_starve_compatible = false
reign_of_giants_compatible = false
hamlet_compatible = false

forge_compatible = false

all_clients_require_mod = true

icon_atlas = "modicon.xml"
icon = "modicon.tex"

server_filter_tags = { "uncompromising", "DSTU", "collab", "overhaul", "hard", "difficult", "madness", "challenge",
    "hardcore" }

priority = -10

------------------------------
-- local functions to makes things prettier

---@param title string
local function Header(title)
    return {
        name = "",
        label = title,
        hover = "",
        options = { { description = "", data = false } },
        default = false
    }
end

local function SkipSpace()
    return {
        name = "",
        label = "",
        hover = "",
        options = { { description = "", data = false } },
        default = false
    }
end

---@param name string
---@param label string
---@param hover string
---@param default boolean
local function BinaryConfig(name, label, hover, default)
    return {
        name = name,
        label = label,
        hover = hover,
        options = { { description = "Enabled", data = true, hover = "Enabled." },
            { description = "Disabled", data = false, hover = "Disabled." } },
        default = default
    }
end
------------------------------

configuration_options = {
    ------------------------------
    -- Beta Compatibility --
    ------------------------------
    --	Header("DST Beta Compatibility"),
    ------------------------------
    --	BinaryConfig("beta_compatibility", "March QoL Beta", "This will enable proper compatibility for the beta Crafting, Ancient Guardian, and Varg Waves features.", false),|
    --	SkipSpace(),

    ------------------------------
    -- Core Gameplay --
    ------------------------------

    Header("Client-Side"),

    BinaryConfig("um_music", "Official Soundtrack", "Disable this if you are crashing when using client music mods or some other incompatibility.",
        true),
    BinaryConfig("um_storms_over", "Tornadoes - Reduced VFX", "Reduces the overall intensity of the visual effects on both the overlay and rain near tornadoes.", false),		
    SkipSpace(),		

    Header("Mod Compatibility"),
	
    BinaryConfig("hungry_void", "Anti-Voidwalk",
        "Disable this if you are using any mods that allow flight or traversal over the cave void.", true),	
    BinaryConfig("nofishyincrockpot", "No Fish in Crockpot", "Disable this if a mod requires live fish for some recipes.", true),
    BinaryConfig("worldgenmastertoggle", "Worldgen Master Toggle", "Toggles ALL worldgen.", true),	
    SkipSpace(),

    Header("In Development"),
    BinaryConfig("ck_loot", "Additional Crab King Loot",
    "Crab King now drops unique loot based on the gems used.\nMissing art assets.", false), 
    SkipSpace(),

    Header("Core Gameplay"),
    --BinaryConfig("caved", "[IMPORTANT] Cave Config",
        --"Switches some things around so players who can't run Caves can still enjoy the game. ENABLE IF CAVES ARE ENABLED!",
        --true),
    BinaryConfig("beefalo_nerf", "Beefalo Nerf", "Players will take half of the damage that the Beefalo takes.", true),		
    {
        name = "fireloot",
        label = "Burning Loot Drop Rework",
        hover =
        "Loot no longer gets destroyed when a mob is burnt to death. Mobs will explode on death, dealing damage and lighting things on fire, based on loot dropped.",
        options = {
            { description = "Off",          data = 1 }, { description = "Explosion Off", data = 2 },
            { description = "Explosion On", data = 3 } },
        default = 3
    },
    BinaryConfig("durability", "Clothing Degradation",
    "Winter and Rain protection clothing items become less effective when their durability drops.", false),	
    BinaryConfig("harder_shadows", "Harder Nightmare Creatures",	
    "Insanity is a bigger threat now. Those who pass the brink may never return.", true),	    		
    BinaryConfig("longpig", "Long Pig", "Skeletons drop Long Pig to prevent Telltale Heart spam.", true),
    
    BinaryConfig("maxhphitters", "Max Health Mob",
        "Some monsters deal Max HP damage.\nTurn this off if you're having problems with mods which also interact Max HP.",
        true),    
    BinaryConfig("maxhungerdamage", "Max Health Starving", "Starving will deal max health damage after a brief delay.", true),
    BinaryConfig("maxtempdamage", "Max Health Temperature", "Freezing and Overheating will deal max health damage after a brief delay.", true),			
	{
        name = "rne chance",
        label = "Night Terrors Chance",
        hover =
        "Night Terrors have a default 40% chance to occur each night. Night Terrors are disabled before Day 5.",
        options = {
            { description = "None", data = 100 }, { description = "10%", data = 0.9 },
            { description = "20%",  data = 0.8 },
            { description = "30%",  data = 0.7 }, { description = "40%", data = 0.6 },
            { description = "50%", data = 0.5 },
            { description = "60%", data = 0.4 }, { description = "70%", data = 0.3 },
            { description = "80%", data = 0.2 },
            { description = "90%", data = 0.1 }, { description = "INSANITY", data = 0 } },
        default = 0.8
    },	
    BinaryConfig("compromising_vortex", "Non-lethal Shadow Vortex",
        "Shadow Vortex now teleports you to some random place.", false),
    BinaryConfig("foodregen", "Over Time Food Stats",
        "Health and Sanity from foods is applied over time, each food acting as a seperate stackable health or sanity regen buff.",
        true),
    BinaryConfig("rat_raids", "Rat Raids", "Rats will periodically be attracted to your base.", true),
    {
        name = "vetcurse",
        label = "Veteran's Curse",
        hover =
        "Veteran's curse is an optional difficulty mode, which increases risk & reward.",
        options = {
            { description = "Default", data = "default" }, { description = "Always On", data = "always" },
            { description = "Off",     data = "off" } },
        default =
        "default"
    },
    SkipSpace(),

    ------------------------------
    -- Character Reworks --
    ------------------------------
    Header("Characters"),
    ------------------------------
    BinaryConfig("wixie_walter", "Wixie & Walter Rework",
        "Enable Uncompromising Mode's Wixie, the Delinquent, who expands on Walter's slingshot, while Walter gets new interactions and mechanics with Woby!",
        true),
    --BinaryConfig("wixie_birds", "Wixie: Slingshot Nerfs", "Slingshots can't hit birds & rabbits.", true),			
    BinaryConfig("funny rat", "Winky", "Enable Uncompromising Mode's Winky, the Vile Vermin.", true),
    BinaryConfig("holy fucking shit it's wathom", "Wathom", "Enable Uncompromising Mode's Wathom, the Forgotten Parody.",
        true),
    {
        name = "wathom_ampvulnerability",
        label = "Wathom - Amped Vulnerability",
        hover =
        "Wathom takes more damage when amped.",
        options = {
            { description = "5x (Default)", data = 5 }, { description = "4x", data = 4 },
            { description = "3x",           data = 3 },
            { description = "2x",           data = 2 } },
        default = 5
    },		
    {
        name = "wathom_armordamage",
        label = "Wathom - Armor Damage",
        hover =
        "Wathom can take increased damage, choose if armor damage is ignored.",
        options = {
            {
                description = "Include Armor",
                data = true,
                hover = "Wathom multiplies incoming damage by the current damage multiplier"
            },
            {
                description = "Don't include armor",
                data = false,
                hover = "Wathom multiplies resulting damage by the current damage multiplier."
            } },
        default = true
    },
    BinaryConfig("wathom_max_dmg", "Wathom - Damage Cap",
        "Wathom's damage is capped at 600 to limit his absurd burst damage potential.", false),    
	BinaryConfig("wathom_undeath", "Wathom - Undeath", "Enables Wathom undeath mechanic when he dies while his adrenaline is high.",
        true),
    BinaryConfig("bernie_buffs", "Willow - Bernie Buffs",
        "Holding Bernie prevents shadows from aggroing.", true),		
    BinaryConfig("willow", "Willow - Lighter Buffs",
        "Willow's Lighter now lasts forever when she holds it.", true),
    --BinaryConfig("willow insulation", "Willow's Experimental Insulation",
        --"Willow's insulation is tweaked to be 120 on Summer and -120 on Winter.", false),
    BinaryConfig("wendy", "Wendy", "Abigail is nerfed to not increase Wendy's maximum damage above average.", true),
    BinaryConfig("wx78", "WX-78", "No longer heals from lightning.", true),
    BinaryConfig("wxless", "WX Rework",
        "Changes the way WX's charge and circuit systems works, alongside the effects of circuits", false),
    {
        name = "wicker_inv_regen_",
        label = "Wicker's Regeneration",
        hover = "Configure how Wickerbottom's books regen.",
        options = {
            {
                description = "Inventory",
                data = "inv",
                hover = "Additionally, bookcase now takes 4 Boards, instead of 2 Living Logs."
            },
            {
                description = "No Regen",
                data = "noregen",
                hover = "Completely disables book regen."
            },
            {
                description = "Bookcase",
                data = "vanilla",
                hover = "Like vanilla."
            }
        },
        default = "inv",
    },
	BinaryConfig("wickerbottom", "Wicker's Sane Reading",
        "Wickerbottom/Maxwell can no longer read books while insane.", true),		
    BinaryConfig("apicultural notes", "Wickerbottom - Apicultural Notes",
        "\"Apicultural Notes\" now adds 1 Honey to up to 10 Bee Boxes around. Doesn't work on Dusk, Night and/or Winter. Now takes a Honeycomb.", true),		
    BinaryConfig("applied horticulture", "Wickerbottom - Horti., Abridged",
        "\"Horticulture, Abridged\" now takes 1 Leafy Meat, instead of 5 seeds.", true),
    BinaryConfig("horticulture, expanded", "Wickerbottom - Horti., Expanded",
        "\"Horticulture, Expanded\" now grows 20 plants, instead of 15. Now takes a Tree Jam, instead of a Feather Pencil.", true),
    BinaryConfig("lunar grimoire", "Wickerbottom - Lunar Grimoire",
        "\"Lunar Grimoire\" now has 4 uses and mutates things around you. Now takes 2 Moon Rocks and 2 Moon Shrooms.", true),		
    BinaryConfig("lux aeterna", "Wickerbottom - Lux and Redux",
        "\"Lux Aeterna\" and \"Lux Aeterna Redux\" now both last longer. \"Lux Aeterna Redux\" now takes a Glow Berry, instead of a Feather Pencil. ", true),		
    BinaryConfig("on tentacles", "Wickerbottom - On Tentacles",
        "On Tentacles now spawns friendly tentacles that die over time, and do not drop tentacle spots.", true),		
    BinaryConfig("the angler", "Wickerbottom - The Angler's",
        "\"The Angler's Survival Guide\" now takes 2 Hardened Slip Bobbers, instead of 2 Wooden Ball Bobbers.", true),
    BinaryConfig("woodie_skilltree", "Woodie's Skilltree", "Some changes to Woodie's skilltrees to add trade-offs and buff underutilized skills.", true),
    BinaryConfig("waxwell", "Maxwell",
        "Maxwell gets buffed versions of his classic shadows by reading the Codex Umbra. Disable for Maxwell mod compatibility!",
        true),
    --	BinaryConfig("wolfgang", "Improved/Balanced Wolfgang", "Wolfgang gains new perks and downsides. Read the patch notes included in the mod folder or workshop for details.", false),
    BinaryConfig("winonaworker", "Winona - Faster Working",
        "Winona now scales her work/picking efficiency, and tool/weapon durability, off of her hunger level. Drains hunger when taking actions.",
        true),
    BinaryConfig("winona_gen_", "Winona - Generators",
        "Limits access to Winona's Generators to only allow her to use them.", false),		
    BinaryConfig("winona_portables_", "Winona - Portable Structures",
        "Makes Winona's structures portable and changes what can be stored into Winona's Toolbox depending if it's enabled or not.", true),
    BinaryConfig("warly_butcher_", "Warly - Butchering",
        "Warly is a certified butcher, he will get more resources from kills in his inventory.",
        true),
    BinaryConfig("warly_food_taste_", "Warly - Food Taste",
        "Warly gets increased stats from food, like Singleplayer. However, he remembers foods for 3 days instead of 2.",
        true),
    BinaryConfig("wortox", "Wortox",
		"Better teleports, worse sanity and healing from souls. Birds and butterflies are soulless.",
		true),
	--{
        --name = "wortox",
        --label = "Wortox",
        --hover =
        --"Wortox has different settings that change his characteristics.",
        --options = {
            --{ description = "SHOT",    data = "SHOT",   hover = "Souls heal over time." },
            --{ description = "Classic", data = "UMNERF", hover = "Less soul sources, less max health." },
            --{
                --description = "Apollo\'s",
                --data = "APOLLO",
                --hover =
                --"Some buffs and nerfs to how Wortox's Souls and stats work. Birds and Butterflies are considered soulless."
            --},
            --{ description = "Vanilla", data = "off" } },
        --default =
        --"UMNERF"
    --},
    BinaryConfig("wormwood_extrafiredmg", "Wormwood - Extra Fire Damage",
        "Increases Wormwood's fire damage multiplier to 1.75x, from 1.25x.", true),
    BinaryConfig("wormwood_plants", "Wormwood - Planting Sanity", "Increases the sanity loss from digging plants by 5.",
        true),		
    BinaryConfig("wormwood_trapbuffs", "Wormwood - Trap Buffs",
        "Bramble traps do no player damage, reset when you are bloomed near them, and create multiple when crafted.",
        true),
    BinaryConfig("wanda_nerf", "Wanda",
        "A bunch of changes to some of Wanda's more overpowered items to make them more balanced.", true),
    SkipSpace(),

    ------------------------------
    -- Weather --
    ------------------------------
    Header("Weather & Seasons"),
    ------------------------------
    {
        name = "weatherhazard_autumn",
        label = "Start Date for Autumn weather",
        hover = "New Autumn weather occurs in the second year by default.\nThis currently only includes poisonous frogs.",
        options = {
            { description = "First Year",  data = 5 },  -- lowered in case someone has a diff starting season, or wants to suffer.
            { description = "Second Year", data = 70 },
            { description = "Third Year",  data = 120 } -- idk math yell at me if wrong
        },
        default = 70
    },
    BinaryConfig("toads", "Toads",
        "Sickly Toads replace Frogs in the second Autumn and occasionally release Spore Clouds on death.", true),
    -- BinaryConfig("acidrain", "Acid Rain", "After the First Year, Toadstool will grow poisionous mushtrees aboveground and pollute the world, making the rain acidic.", true),
    SkipSpace(),

    {
        name = "weatherhazard_winter",
        label = "Start Date for Winter weather",
        hover =
        "New Winter weather occurs in the first year, by default.",
        options = {
            { description = "First Year", data = 5 }, { description = "Second Year", data = 70 },
            { description = "Third Year", data = 120 } },
        default = 5
    },

    BinaryConfig("winter_burning", "Harder Burning",
        "Winter makes it so setting stuff alight takes more time, and also finish burning faster.", true),
    BinaryConfig("snowstorms", "Snowstorms",
        "Snowtorms impede on players' speed and vision if they are not wearing eye protection. Snowstorms also causes snow to build up on structures.",
        true),		
    SkipSpace(),

    {
        name = "weatherhazard_spring",
        label = "Start Date for Spring weather",
        hover =
        "New Spring weather occurs in the first year, by default.",
        options = {
            { description = "First Year", data = 5 }, { description = "Second Year", data = 70 },
            { description = "Third Year", data = 120 } },
        default = 5
    },
    BinaryConfig("um_storms", "Tornadoes", "Tornadoes sweep across the land, bringing heavy rain and lightning!", true),
    {
        name = "um_storms_performance",
        label = "Tornadoes - Less Lag",
        hover =
        "Simplifies some of tornadoes' interactions with the world to help with performance for lower-end systems.",
        options = {
            { description = "Disabled",        data = "off",     hover = "Tornado does everything." },
            { description = "Reduced Effects", data = "reduced", hover = "Simplified interactions, doesn't work off-screen." },
            { description = "Minimal Effects", data = "minimal", hover = "Removes all direct non-player interactions." },
        },
        default = "off"
    },
    SkipSpace(),

    {
        name = "weatherhazard_summer",
        label = "Start Date for Summer weather",
        hover = "New Summer weather occurs in the first year, by default.",
        options =
        {
            { description = "First Year",  data = 22 },
            { description = "Second Year", data = 70 },
            { description = "Third Year",  data = 120 },
        },
        default = 22,
    },
    BinaryConfig("heatwaves", "Heat Waves",
        "Heat waves act as a summer counterpart to snowstorms.\nWhile they don't do much on their own, aside from the temperature increase, they interact with Smog and Pyre Nettles.",
        true),	
    BinaryConfig("hotcaves", "Hotter Caves", "During Summer, caves are just hot enough to overheat you without any gear.",
        true),
    BinaryConfig("pyrenettles", "Pyre Nettles", "Pyre Nettles are a new invasive cave plant that grows with heat.", true),
    BinaryConfig("smog", "Smog",
        "Burning plants in summer releases large quantities of smoke. Meant to interact with heatwaves.", true),
    SkipSpace(),

    --[[ This section disabled until we actually use it.
------------------------------
-- Gamemode --
------------------------------
	Header("Gamemode"),
------------------------------
	{
		name = "gamemode",
		label = "Mode",
		hover = "Currently, there are no other modes.", --"Choose gamemode. 1) Original Uncompromising version (default settings). 2) Mod is enabled after first Fuelweaver is defeated. 3) Choose custom settings.",
		options =
		{
			{description = "Uncompromising", data = 0}, -- TODO: When this is selected, disable the below ones (gray them out)
			--{description = "Custom", data = 2}, --TODO: On custom, enable editing the below settings
		},
		default = 0,
	},
	SkipSpace(),
]]

    ------------------------------
    -- World Gen --
    ------------------------------
    Header("World Gen"),
    ------------------------------
    BinaryConfig("hoodedforest", "Hooded Forest",
        "Hooded Forest replaces the Moon Base forest, with brand new things to explore, including a new boss!", true),
    {
        name = "ghostwalrus",
        label = "Rusty Traps",
        hover =
        "The MacTusks forgot to pick up their traps and left them to rust.",
        options = {
            { description = "Enabled",              data = "enabled" },
            { description = "Enabled (No Respawn)", data = "norespawn", hover = "Traps don't respawn over time." },
            { description = "Disabled",             data = "disabled" } },
        default =
        "enabled"
    },
    BinaryConfig("rice", "Rice", "Rice spawns in swamp ponds.", true),
    BinaryConfig("trapdoorspiders", "Trapdoor Spiders",
        "Enables the spawning of Trapdoor Spider mounds on worldgen. Their dens are usually covered in a resource rich grass.",
        true),
    SkipSpace(),

    ------------------------------
    -- Rats --
    ------------------------------
    Header("Rats"),
    ------------------------------
    BinaryConfig("itemcheck", "Item Score", "Equippable items and mole bait items increase the \'rat score\' value.",
        true),
    {
        name = "rattimer",
        label = "Rat Raid Cooldown",
        hover = "The cooldown between Rat Raids!",
        options = {
            { description = "As soon as possible.", data = 10 }, { description = "Half", data = 4800 },
            { description = "Default",              data = 9600 }, { description = "Double", data = 14400 } },
        default = 9600
    },
    {
        name = "ratgrace",
        label = "Rat Raid Grace Period",
        hover =
        "Minimum grace period, during which Rats are unable to invade!",
        options = {
            { description = "As soon as possible.", data = 1 }, { description = "Low[15 days]", data = 15 },
            { description = "Default[30 days]",     data = 30 }, { description = "Medium[45 days]", data = 45 },
            { description = "High[60 days]", data = 60 } },
        default = 30
    },	
    {
        name = "ratsnifftimer",
        label = "Rat Sniff Timer",
        hover =
        "The rate at which your base is checked for messiness.",
        options = {
            { description = "Lowest[1 Minute]",   data = 60 }, { description = "Lowered[2 Minutes]", data = 120 },
            { description = "Default[3 Minutes]", data = 180 }, { description = "Raised[4 Minutes]", data = 240 },
            { description = "Extended[8 Minutes]", data = 480 } },
        default = 120
    },
    SkipSpace(),

    -----------------------------
    -- Items and Structures --
    -----------------------------
    Header("Items and Structures"),
    -----------------------------
	
	BinaryConfig("ac_does_ac", "Air Conditioning Air Conditioner", "Air Conditioner works as a reverse furnace, cooling in a small area, and removes smog around it.", false),
    BinaryConfig("lifeinjector_rework", "Booster Shot Rework", "The Booster Shot regenerates 50% of your max health loss overtime.", true),
    BinaryConfig("canedurability", "Cane Durability",
        "Cane loses durability similarly to a Whirly Fan. Note that MacTusks will drop Tusks 100% of the time with this on.",
        false),	
    {
        name = "pocket_powertrip",
        label = "Clothing Pockets",
        hover = "Gives some underused dress items pockets.",
        options = {
            { description = "On",  data = 1 },
            {
                description = "On (Backpack-like)",
                data = 2,
                hover = "Items with pockets act like backpacks. However, they can't be stored in the inventory."
            },
            { description = "Off", data = 0 } },
        default = 1
    },
	BinaryConfig("compostoverrot", "Compost Replaces Rot", "Compost replaces Rot in most recipes. Keep in mind the Composting Bin is buffed.\nBooster Shots take Red Caps instead.", true),    
    BinaryConfig("cookiecutterhat", "Cookie Cutter Hat",
        "Cookie Cutter Caps now reflects some damage back at the attacker.", true),
    BinaryConfig("cooldown_orangestaff_", "Cooldown Based Lazy Explorer",
        "Lazy Explorer no longer has durabilty, but instead has cooldown, like Wanda's watches.\nSuggested by Lux.",
        false),			
    {
        name = "electricalmishap",
        label = "Electrical Weapon Retune",
        hover =
        "Controls how electrical weapons (Bug Zapper and Morning Star) behave.",
        options = {
            {
                description = "Electrical Mishap",
                data = 1,
                hover = "Weapons can be charged with Lightning and Generators."
            },
            {
                description = "Classic",
                data = 2,
                hover = "Weapons can be refueled with certain electricity-related items."
            },
            { description = "Off", data = 0 } },
        default = 1
    },	
	{
        name = "flingo_setting",
        label = "Flingomatic Nerf",
        hover =
        "Pick the Flingomatic nerf you would like to play around.",
        options = {
            { description = "Fuel loss in use",  data = "Fuelmuncher" },
            { description = "No longer freezes", data = "Waterballs" }, { description = "None", data = "Newb" } },
        default =
        "Waterballs"
    },
    BinaryConfig("hambatnerf", "Ham Bat Nerf", "Spoils faster and minimum damage is lower.", true),	
	
    BinaryConfig("townportal_rework", "Lazy Deserter Rework",
        "Makes the Lazy Deserter useful in singleplayer, by automatically harvesting nearby plants and objects.", true),
    BinaryConfig("lifeamulet", "Life Giving Amulet Rework",
        "The Amulet won't revive ghosts, but it now interrupts death upon taking a fatal hit while wearing it.\nIts hunger > health conversion ticks much faster.",
        true),
    BinaryConfig("no4crafts", "No 4-Ingredient Recipes", "Changes all 4-ingredient recipes to use 3 instead.", false),		
    BinaryConfig("passibleimpassibles", "Remove Cheese-able Collisions",
        "Removes collision from objects like statues to prevent cheesing mobs and bosses.", true),			
    BinaryConfig("scalemailbuff", "Scalemail Buff", "Scalemail now spawns 3 Dimvaes to help you in combat.", true),		
    BinaryConfig("scaledchestbuff", "Scaled Chest Buff",
        "Enabling this buffs Scaled Chest to 25 slots. Toggling with Scaled Chests existing in the world may cause a crash.",
        true),
    BinaryConfig("sewingkit", "Sewing Kit Rework",
        "Sewing Kit has DOUBLE uses, but repairs HALF value. Pairs very well with Clothing Degredation, lets you keep clothing in top shape more easily.",
        true),
    {
        name = "gotobed",
        label = "Sleeping Buff",
        hover =
        "Sleeping can heal max health loss. Siesta Lean-to cost to craft and cost to use nerfed.",
        options = {
            { description = "Default",  data = "default", hover = "Only heal max health loss if BELOW 25%." },
            { description = "Legacy",   data = "legacy",  hover = "Heal max health lost regardless of %." },
            { description = "Disabled", data = false } },
        default =
        "default"
    },
    {
        name = "sleepingbuff",
        label = "Sleeping Stat Speed",
        hover =
        "Increases the speed at which sleeping gives stats/drains hunger. Default 1.5x.",
        options = {
            { description = "2x Faster", data = 2 }, { description = "1.5x Faster", data = 1.5 },
            { description = "Vanilla",   data = 1 } },
        default = 1.5
    },	
    BinaryConfig("telestaff_rework", "Telelocator Rework",
        "You can now select the Focus you wish to teleport to. Foci now cost 3 Purple gems instead of gold.\nThe Staff's uses are doubled.",
        true),
    BinaryConfig("insul_thermalstone", "Thermal Stone Rework",
    "Thermal Stones now have less insulation, but inherit some insulation from clothing.", true),        
    BinaryConfig("uncool_chester", "Ther. Stone Snow Chester Nerf",
    "Snow Chester will no longer freeze Thermal Stones.", true),		

    SkipSpace(),
    -----------------------------
    -- Food --
    -----------------------------
    Header("Food"),
    -----------------------------
    Header("Crockpot Recipes"),
    BinaryConfig("crockpotmonstmeat", "Harder Monster Meat",
        "Enables the new Monster Lagsana recipe; you can only make non-monster recipes if the meat value is greater than monster value.",
        true),    
    BinaryConfig("newrecipes", "New Recipes",
        "UM adds a few new Crockpot recipes,\nTurn this off if you're using mods that can cause overlap, such as HoF.",
        true),
    BinaryConfig("icecrockblocker", "Snowcones",
        "Snowcones prevent heavy use of Ice specifically in Crockpot dishes that don't call for it.", true),        
    BinaryConfig("generalcrockblocker", "Trash Filler Blocker",
        "Heavy use of certain low quality Crockpot ingredients, such as Twigs, Ice, Buttefly Wings, and other inedibles will result in Wet Goop.",
        true),
    SkipSpace(),

    Header("Crockpot Food Tweaks"),
    BinaryConfig("farmfoodredux", "Farmplot Food Redux",
        "Reallocates most dishes that involve Crock Pot foods. Typically a buff, but may exchange some stats.", true),    
    BinaryConfig("sr_foodrebalance", "Fish Foods Rebalance", "Several fish based foods have their stats tweaked.", true),        
    BinaryConfig("goodies_nerf", "Goodies Food Type Changes", "The food type of more avaliable Goodies were changed into either Veggie or Generic.", true),	    
    BinaryConfig("icecream_buff", "Ice Cream Buff", "Ice Cream now restores 100 sanity.", true),    
    BinaryConfig("meatball", "Meatball Nerf", "Meatballs restore 50 hunger instead of 62.5.", true),
    {
        name = "perogi",
        label = "Pierogi Recipe Nerf",
        hover = "Pierogis require more veggies to cook.",
        options = {
            { description = "1.5 Veggie Value", data = 1.5 }, { description = "2 Veggie Value", data = 2 },
            { description = "1 Veggie Value",   data = 1 }, { description = "Vanilla Value", data = 0.5 } },
        default = 1.5
    },
    SkipSpace(),

    Header("General Food Tweaks"),
    BinaryConfig("beebox_nerf", "Bee Box Nerf", "Bee Boxes only release 2 Bees max.", true),  
    BinaryConfig("butterflywings_nerf", "Butterfly Wings Nerf",
        "Butterfly Wings have been nerfed to not be cheap healing.", true),     
    {
        name = "more perishing",
        label = "Increased Food Spoilage",
        hover = "Food spoils faster. It's as simple as that.",
        options = {
            { description = "Disabled(1x)", data = 1 }, { description = "1.5x", data = 1.5 },
            { description = "2x",           data = 2 }, { description = "2.5x", data = 2.5 },
            { description = "3x", data = 3 } },
        default = 1.5
    },     
    BinaryConfig("seeds", "Lowered Seeds Hunger", "Seeds have had their hunger lowered.", true),  
    {
        name = "monster_eggs",
        label = "Monster Eggs",
        hover =
        "Birds now give Monster Eggs when fed Monster Meat.\nMonster Eggs are like Eggs, but have configurable monster value.",
        options = {
            { description = "Off",         data = 0 }, { description = "0.25 Monster", data = 0.25 },
            { description = "0.5 Monster", data = 0.5 }, { description = "1 Monster", data = 1 },
            { description = "1.5 Monster", data = 1.5 } },
        default = 1.5
    },      
    BinaryConfig("monstersmallmeat", "Monster Morsel",
        "Small creatures like Spiders drop monster morsels instead of Monster Meat.", true),
    BinaryConfig("horriblefood", "More Horrible Foods",
        "More items are considered as the horrible food type.", true),        
    BinaryConfig("no_winter_growing", "No Winter Growing",
        "Makes a few food sources such as Kelp and Stone Fruit not grow in Winter.", true),
    BinaryConfig("rawcropsnerf", "Raw Crops Nerf",
        "Farm crops are nerfed in their base value when raw/cooked to incentivize using Crockpot recipes.", true),        

    SkipSpace(),

    -----------------------------
    -- Monsters --
    -----------------------------
    Header("Monsters"),
    -----------------------------
    Header("New Hounds"),
    BinaryConfig("glacialhounds", "Glacial Hounds", "Glacial Hounds are part of Hound waves.", true),    
    BinaryConfig("lightninghounds", "Lightning Hounds", "Lightning Hounds are part of Hound waves.", true),
    BinaryConfig("magmahounds", "Magma Hounds", "Magma Hounds are part of Hound waves.", true),
    BinaryConfig("sporehounds", "Spore Hounds", "Spore Hounds are part of Hound waves.", true),
    SkipSpace(),

    Header("Harder Hounds"),
    BinaryConfig("firebitehounds", "Fiery Bite", "Red Hounds set players on fire when they attack.", true),
    BinaryConfig("frostbitehounds", "Frozen Bite", "Blue Hounds freeze players when they attack.", true),
    SkipSpace(),

    Header("Wave Changes"),
    BinaryConfig("lategamehoundspread", "Decreased Lategame Frequency",
        "Enabling this decreases the frequency in the lategame so Hounds are still a threat, but not annoying.", true),

    --[[ This section has overlap with a vanilla update.
	BinaryConfig("vargwaves", "Vargs in Hound Waves", "In the lategame, vargs will accompany hounds in houndwaves.", true),
	{
		name = "vargwaves grace",
		label = "Varg Grace Period.",
		hover = "Vargs cannot spawn in hound waves until this amount of days have passed.",
		options =
		{
			{description = "No grace period.", data = 0},
			{description = "20 days", data = 20},
			{description = "40 days", data = 40},
			{description = "60 days", data = 60},
			{description = "70 days", data = 70},
			{description = "80 days", data = 80},
			{description = "100 days", data = 100},
			{description = "120 days", data = 120},
			{description = "140 days", data = 140},
			{description = "160 days", data = 160},
			{description = "180 days", data = 180},
			{description = "200 days", data = 200},
		},
		default = 100,
	},
	{
		name = "vargwaves delay",
		label = "Delay Between Varg Spawns.",
		hover = "Vargs cannot spawn before this amount days have passed since the last Varg spawn.",
		options =
		{
			{description = "No grace period.", data = 0},
			{description = "5 days", data = 5},
			{description = "10 days", data = 10},
			{description = "15 days", data = 15},
			{description = "20 days", data = 20},
			{description = "25 days", data = 25},
			{description = "30 days", data = 30},
		},
		default = 15,
	},
]]
    SkipSpace(),

    Header("New Depths Worms"),
    BinaryConfig("depthseels", "Depths Eels", "Electrified Depths Eels join the Worm pack in Winter and Spring.", true),
    BinaryConfig("depthsvipers", "Depths Vipers", "Mysterious Depths Vipers join the Worm pack in Summer and Autumn.",
        true),
    SkipSpace(),
    
    Header("Bats"),
    --	BinaryConfig("hardbatilisks", "Harder Batilisks", "Batilisk's health is increased from 50 to 75, drops Wings less often than vanilla, and drops Monster Morsels.", true),
    BinaryConfig("adultbatilisks", "Adult Batilisks",
        "Adult Batilisks spawn under certain conditions instead of regular ones. They are harder, but have better loot on average.",
        true),
    BinaryConfig("batspooking", "Bat Sinkhole Evacuation",
        "Sinkholes will spawn all of their Bats as soon as they are regenerated, instead of slowly trickling out.", true),
    SkipSpace(),

    Header("Spiders"),
    BinaryConfig("alljumperspiders", "Regular Spiders Jump", "Normal Spiders leap, just like Spider Warriors.", true),
    BinaryConfig("spiderwarriorcounter", "Warrior Counter",
        "Warrior Spiders (and Depth Dwellers) perform a counter-attack when attacked (also lowers health to 300).", true),
    SkipSpace(),

    Header("New Ruins Monsters"),
    BinaryConfig("trepidations", "Ancient Trepidations",
        "Enabling this allows Trepidations to roam the halls of the ruins during the Nightmare Phase, seeking out the weak of mind.",
        true),
    BinaryConfig("nodespawn_trepidation", "Ancient Trepidations - Despawn",
        "Enabling this will prevent the Ancient Trepidation from despawning after the Nightmare Phase calms down.",
        false),
    BinaryConfig("amalgams", "Clockwork Amalgams",
        "Enabling this allows Pawns and Broken Clockwork piles to spawn Clockwork Amalgmas", true),        
    BinaryConfig("pawns", "Clockwork Pawns",
        "Enabling this allows Pawns to patrol the depths of the caves, drawing unwanted attention to the foolish and lost.",
        true),
    SkipSpace(),

    Header("Misc Monsters"),
    BinaryConfig("noauradamage_butterfly", "AoE Immune Butterflies",
    "Butterflies are immune to AoE damage, such as catapults and Abigail.", true),
    BinaryConfig("_bushcrabs", "Bush Crabs", "Bush Crabs ambush the player when digging up berry bushes.", true), 
    BinaryConfig("harder_krampus", "Harder Krampus", "Krampii now have a new attack, with knockback.", true),   
    BinaryConfig("pigking_guards", "Pig King Guards",
        "Pig King now has neutral guards watching for any suspicious activity.", true),
    BinaryConfig("pinelings", "Pinelings",
        "Stumps will become pinelings if awoken by a treeguard, or if stumps are left for long enough.", true),
    BinaryConfig("desertscorpions", "Scorpions",
        "Scorpions plague the Oasis Desert during Dusk and Night. They will spawn from Scorpion Holes spread around the biome.",
        true),
    --BinaryConfig("pollenmites", "Pollen Mites", "Pollen mites spawn in spring and quickly infest the nearby area.", false),
    SkipSpace(),

    Header("Standard Creatures"),
    BinaryConfig("angry_werepigs", "Angry Werepigs", "Werepigs prioritize attacking over eating.", true),
    BinaryConfig("cowardfrogs", "Frog Anti-cheese", "Frogs flee from bosses to prevent cheesing.", true),
    BinaryConfig("harder_beefalo", "Harder Beefalo", "Beefalo ocasionally charge after a telegraph.", true),
    BinaryConfig("harder_koalefants", "Harder Koalefants", "Koalefants have brand new attacks and doubled health.", true),
    BinaryConfig("harder_walrus", "Harder MacTusk", "MacTusk has a counter attack and can throw traps.", true),
    BinaryConfig("harder_pigs", "Harder Pigs", "Pigs have a new counter and charge attack.", true),
    BinaryConfig("hungryfrogs", "Hungry Frogs", "Frogs eat anything left on the floor.", true),
    BinaryConfig("mermtweaks", "Merm Tweaks", "Regular Merms can now leave their houses during winter, Merm Guards respawn slower.", true),
    BinaryConfig("sharpshooter_monkeys", "Sharpshooter Powder Monkeys", "Powder monkeys actually aim their cannons and fire at anything they may consider 'fun' shooting at.", true),
    BinaryConfig("fiendforcedmetodothis", "Slurtle Tweaks", "Slurtles attack faster, have less health and drop Shellmets more often.", true),
    BinaryConfig("angrypenguins", "Territorial Penguins", "Penguins will aggresively defend their land.", true),
    SkipSpace(),

    -----------------------------
    -- Bosses --
    -----------------------------
    Header("Bosses"),
    -----------------------------
    Header("Additional Seasonal Giants"),
    BinaryConfig("mother_goose", "Mother Goose",
        "Mother Goose will now attack the player in Spring, similar to the Reign of Giants' Moose.", true),
    {
        name = "mother_goose_spawn",
        label = "Mother Goose - Spawn Date",
        hover = "The year that Mother Goose can spawn.",
        options = {
            { description = "Year 1 (Default)", data = 26 },
            { description = "Year 2",           data = 50 },    -- maybe???
            { description = "Year 3",           data = 50 * 2 } -- ???
        },
        default = 26
    },
    BinaryConfig("wiltfly", "Wilting Dragonfly",
        "Dragonfly will now leave her arena during Summer and attack the player, similar to Reign of Giants' Dragonfly.",
        true),
    {
        name = "wiltfly_spawn",
        label = "Wilting Dragonfly - Spawn Date",
        hover = "The year that Wilting Dragonfly can spawn.",
        options = {
            { description = "Year 1 (Default)", data = 26 },
            { description = "Year 2",           data = 26 * 2 }, -- maybe???
            { description = "Year 3",           data = 26 * 3 }  -- ???
        },
        default = 26
    },
    SkipSpace(),

    Header("Giants & Bosses"),
    BinaryConfig("harder_deerclops", "Deerclops Mutations",
        "Three different, harder variants of Deerclops can spawn, replacing the vanilla version.", true),
    BinaryConfig("disable_megaflare", "Disable Hostile Flare", "Hostile Flares no longer spawn Deerclops.", true),    
    BinaryConfig("harder_bearger", "Harder Bearger",
        "Enabling this option grants Bearger more attacks, and will make Bearger more actively seek you out.", true),    
    BinaryConfig("harder_moose", "Harder Goose",
        "Goose fight has more mechanics and is harder. This also disables Moose AOE. Does not apply to Mother Goose.",
        true),    
    BinaryConfig("harder_spider_queen", "Harder Spider Queen",    
    "Spider Queens ocasionally spit web balls that trap players.", false),
    BinaryConfig("harder_leifs", "Harder Treeguard",
    "Enabling this option makes Treeguards attack in AoE, perform root attacks, inflict knockback, and summon Pinelings.", true),        
    SkipSpace(),

    Header("Raid Bosses"),
    BinaryConfig("harder_lavae", "Dragonfly's Exploding Lavae",
        "Lavae will now leave exploding paste upon death, capable of destroying walls.", true),    
    BinaryConfig("rework_minotaur", "Ancient Guardian Rework",
        "The Ancient Guardian's fight is expanded, including more attacks.", true),    
    BinaryConfig("harder_beequeen", "Bee Queen Rework",
    "Bee Queen now has a variety of attacks utilizing new types of Bees.", true), -- lame! help!
    BinaryConfig("reworked_ck", "Crab King Rework",
        "Crab King has his main attack altered, freeze removed, and some new mechanics.", true),    
    BinaryConfig("reworked_eyes", "Eyes of Terror Rework",
        "Eye of Terror and the Twins have new attacks, inspired by their Terraria counterparts.", true),
    BinaryConfig("changed_shadow_pieces", "Shadow Pieces Rework",
        "Shadow Bishop has a different attack.", true),
    SkipSpace(),

    Header("Boss Quality of Life"),
	
	{
        name = "Ancient Fuelweaver's Health",
        label = "Ancient Fuelweaver's Health",
        hover = "Tweak Ancient Fuelweaver's Health to your liking!",
        options = {
			{ description = "Lowest (/4)", data =  0.25},
			{ description = "Lowered (/2)", data = 0.5 },			
            { description = "Default", data = 1 },
            { description = "Higher (x1.5)", data = 1.5 },
            { description = "Highest (x2)", data = 2 },
            { description = "Uncomp (x3)", data = 3 } },
        default = 1
    },		
	{
        name = "Ancient Guardian's Health",
        label = "Ancient Guardian's Health",
        hover = "Tweak Ancient Guardian's Health to your liking!",
        options = {
			{ description = "Lowest (/4)", data =  0.25},
			{ description = "Lowered (/2)", data = 0.5 },			
            { description = "Default", data = 1 },
            { description = "Higher (x1.5)", data = 1.5 },
            { description = "Highest (x2)", data = 2 },
            { description = "Uncomp (x3)", data = 3 } },
        default = 1
    },	
	{
        name = "Antlion's Health",
        label = "Antlion's Health",
        hover = "Tweak Antlion's Health to your liking!",
        options = {
			{ description = "Lowest (/4)", data =  2000 },
			{ description = "Lowered (/2)", data = 3000 },			
            { description = "Default", data = 6000 },
            { description = "Higher (x1.5)", data = 9000 },
            { description = "Highest (x2)", data = 12000 },
            { description = "Uncomp (x3)", data = 18000 } },
        default = 6000
    },
	{	
        name = "Bearger's Health",
        label = "Bearger's Health",
        hover = "Tweak Bearger's Health to your liking!",
        options = {
			{ description = "Lowest (/4)", data =  0.25},
			{ description = "Lowered (/2)", data = 0.5 },			
            { description = "Default", data = 1 },
            { description = "Higher (x1.5)", data = 1.5 },
            { description = "Highest (x2)", data = 2 },
            { description = "Uncomp (x3)", data = 3 } },
        default = 1
    },
	{
        name = "Bee Queen's Health",
        label = "Bee Queen's Health",
        hover = "Tweak Bee Queen's Health to your liking!",
        options = {
			{ description = "Lowest (/4)", data =  0.25},
			{ description = "Lowered (/2)", data = 0.5 },			
            { description = "Default", data = 1 },
            { description = "Higher (x1.5)", data = 1.5 },
            { description = "Highest (x2)", data = 2 },
            { description = "Uncomp (x3)", data = 3 } },
        default = 1
    },	
	{	
        name = "Celestial Champion's Health",
        label = "Celestial Champion's Health",
        hover = "Tweak Celestial Champion's Health to your liking!",
        options = {
			{ description = "Lowest (/4)", data =  0.25},
			{ description = "Lowered (/2)", data = 0.5 },			
            { description = "Default", data = 1 },
            { description = "Higher (x1.5)", data = 1.5 },
            { description = "Highest (x2)", data = 2 },
            { description = "Uncomp (x3)", data = 3 } },
        default = 1
    },	
	{	
        name = "Crab King's Health",
        label = "Crab King's Health",
        hover = "Tweak Crab King's Health to your liking!",
        options = {
			{ description = "Lowest (/4)", data =  5000},
			{ description = "Lowered (/2)", data = 10000 },			
            { description = "Default", data = 20000 },
            { description = "Higher (x1.5)", data = 30000 },
            { description = "Highest (x2)", data = 40000 },
            { description = "Uncomp (x3)", data = 60000 } },
        default = 20000
    },		
	{	
        name = "Deerclops's Health",
        label = "Deerclops's Health",
        hover = "Tweak Deerclops's Health to your liking!",
        options = {
			{ description = "Lowest (/4)", data =  0.25},
			{ description = "Lowered (/2)", data = 0.5 },			
            { description = "Default", data = 1 },
            { description = "Higher (x1.5)", data = 1.5 },
            { description = "Highest (x2)", data = 2 },
            { description = "Uncomp (x3)", data = 3 } },
        default = 1
    },		
	{	
        name = "Dragonfly's Health",
        label = "Dragonfly's Health",
        hover = "Tweak Dragonfly's Health to your liking!",
        options = {
			{ description = "Lowest (/4)", data =  0.25},
			{ description = "Lowered (/2)", data = 0.5 },			
            { description = "Default", data = 1 },
            { description = "Higher (x1.5)", data = 1.5 },
            { description = "Highest (x2)", data = 2 },
            { description = "Uncomp (x3)", data = 3 } },
        default = 1
    },		
	{	
        name = "Eye of Terror's Health",
        label = "Eye of Terror's Health",
        hover = "Tweak Eye of Terror's Health to your liking!",
        options = {
			{ description = "Lowest (/4)", data =  0.25},
			{ description = "Lowered (/2)", data = 0.5 },			
            { description = "Default", data = 1 },
            { description = "Higher (x1.5)", data = 1.5 },
            { description = "Highest (x2)", data = 2 },
            { description = "Uncomp (x3)", data = 3 } },
        default = 1
    },
	{	
        name = "Frostjaw's Health",
        label = "Frostjaw's Health",
        hover = "Tweak Frostjaw's Health to your liking!",
        options = {
			{ description = "Lowest (/4)", data =  0.25},
			{ description = "Lowered (/2)", data = 0.5 },			
            { description = "Default", data = 1 },
            { description = "Higher (x1.5)", data = 1.5 },
            { description = "Highest (x2)", data = 2 },
            { description = "Uncomp (x3)", data = 3 } },
        default = 1
    },
	{	
        name = "Hooded Widow's Health",
        label = "Hooded Widow's Health",
        hover = "Tweak Hooded Widow's Health to your liking!",
        options = {
			{ description = "Lowest (/4)", data =  0.25},
			{ description = "Lowered (/2)", data = 0.5 },			
            { description = "Default", data = 1 },
            { description = "Higher (x1.5)", data = 1.5 },
            { description = "Highest (x2)", data = 2 },
            { description = "Uncomp (x3)", data = 3 } },
        default = 1
    },	
	{	
        name = "Klaus's Health",
        label = "Klaus's Health",
        hover = "Tweak Klaus's Health to your liking!",
        options = {
			{ description = "Lowest (/4)", data =  2500},
			{ description = "Lowered (/2)", data = 5000 },			
            { description = "Default", data = 10000 },
            { description = "Higher (x1.5)", data = 15000 },
            { description = "Highest (x2)", data = 20000 },
            { description = "Uncomp (x3)", data = 30000 } },
        default = 10000
    },		
	{	
        name = "Lord of the Fruit Flies's Health",
        label = "Lord of the Fruit Flies's Health",
        hover = "Tweak Lord of the Fruit Flies's Health to your liking!",
        options = {
			{ description = "Lowest (/4)", data =  0.25},
			{ description = "Lowered (/2)", data = 0.5 },			
            { description = "Default", data = 1 },
            { description = "Higher (x1.5)", data = 1.5 },
            { description = "Highest (x2)", data = 2 },
            { description = "Uncomp (x3)", data = 3 } },
        default = 1
    },	
	{	
        name = "Malbatross's Health",
        label = "Malbatross's Health",
        hover = "Tweak Malbatross's Health to your liking!",
        options = {
			{ description = "Lowest (/4)", data =  0.25},
			{ description = "Lowered (/2)", data = 0.5 },			
            { description = "Default", data = 1 },
            { description = "Higher (x1.5)", data = 1.5 },
            { description = "Highest (x2)", data = 2 },
            { description = "Uncomp (x3)", data = 3 } },
        default = 1
    },
	{	
        name = "Misery Toadstool's Health",
        label = "Misery Toadstool's Health",
        hover = "Tweak Misery Toadstool's Health to your liking!",
        options = {
			{ description = "Lowest (/4)", data =  0.25},
			{ description = "Lowered (/2)", data = 0.5 },			
            { description = "Default", data = 1 },
            { description = "Higher (x1.5)", data = 1.5 },
            { description = "Highest (x2)", data = 2 },
            { description = "Uncomp (x3)", data = 3 } },
        default = 1
    },			
	{	
        name = "Moonmaw Dragonfly's Health",
        label = "Moonmaw Dragonfly's Health",
        hover = "Tweak Moonmaw Dragonfly's Health to your liking!",
        options = {
			{ description = "Lowest (/4)", data =  0.25},
			{ description = "Lowered (/2)", data = 0.5 },			
            { description = "Default", data = 1 },
            { description = "Higher (x1.5)", data = 1.5 },
            { description = "Highest (x2)", data = 2 },
            { description = "Uncomp (x3)", data = 3 } },
        default = 1
    },	
	{	
        name = "Moose/Geese's Health",
        label = "Moose/Geese's Health",
        hover = "Tweak Moose/Geese's Health to your liking!",
        options = {
			{ description = "Lowest (/4)", data =  0.25},
			{ description = "Lowered (/2)", data = 0.5 },			
            { description = "Default", data = 1 },
            { description = "Higher (x1.5)", data = 1.5 },
            { description = "Highest (x2)", data = 2 },
            { description = "Uncomp (x3)", data = 3 } },
        default = 1
    },
	{	
        name = "Mother Goose's Health",
        label = "Mother Goose's Health",
        hover = "Tweak Mother Goose's Health to your liking!",
        options = {
			{ description = "Lowest (/4)", data =  0.25},
			{ description = "Lowered (/2)", data = 0.5 },			
            { description = "Default", data = 1 },
            { description = "Higher (x1.5)", data = 1.5 },
            { description = "Highest (x2)", data = 2 },
            { description = "Uncomp (x3)", data = 3 } },
        default = 1
    },	
	{	
        name = "Nightmare Werepig's Health",
        label = "Nightmare Werepig's Health",
        hover = "Tweak Nightmare Werepig's Health to your liking!",
        options = {
			{ description = "Lowest (/4)", data =  0.25},
			{ description = "Lowered (/2)", data = 0.5 },			
            { description = "Default", data = 1 },
            { description = "Higher (x1.5)", data = 1.5 },
            { description = "Highest (x2)", data = 2 },
            { description = "Uncomp (x3)", data = 3 } },
        default = 1
    },	
	{	
        name = "Reanimated Skeleton's Health",
        label = "Reanimated Skeleton's Health",
        hover = "Tweak Reanimated Skeleton's Health to your liking!",
        options = {
			{ description = "Lowest (/4)", data =  0.25},
			{ description = "Lowered (/2)", data = 0.5 },			
            { description = "Default", data = 1 },
            { description = "Higher (x1.5)", data = 1.5 },
            { description = "Highest (x2)", data = 2 },
            { description = "Uncomp (x3)", data = 3 } },
        default = 1
    },		
	{	
        name = "Shadow Pieces's Health",
        label = "Shadow Pieces's Health",
        hover = "Tweak Shadow Pieces's Health to your liking!",
        options = {
			{ description = "Lowest (/4)", data =  0.25},
			{ description = "Lowered (/2)", data = 0.5 },			
            { description = "Default", data = 1 },
            { description = "Higher (x1.5)", data = 1.5 },
            { description = "Highest (x2)", data = 2 },
            { description = "Uncomp (x3)", data = 3 } },
        default = 1
    },	
	{	
        name = "Spider Queen's Health",
        label = "Spider Queen's Health",
        hover = "Tweak Spider Queen's Health to your liking!",
        options = {
			{ description = "Lowest (/4)", data =  0.25},
			{ description = "Lowered (/2)", data = 0.5 },			
            { description = "Default", data = 1 },
            { description = "Higher (x1.5)", data = 1.5 },
            { description = "Highest (x2)", data = 2 },
            { description = "Uncomp (x3)", data = 3 } },
        default = 1
    },	
	{	
        name = "Toadstool's Health",
        label = "Toadstool's Health",
        hover = "Tweak Toadstool's Health to your liking!",
        options = {
			{ description = "Lowest (/4)", data =  0.25},
			{ description = "Lowered (/2)", data = 0.5 },			
            { description = "Default", data = 1 },
            { description = "Higher (x1.5)", data = 1.5 },
            { description = "Highest (x2)", data = 2 },
            { description = "Uncomp (x3)", data = 3 } },
        default = 1
    },	
	{	
        name = "Treeguard's Health",
        label = "Treeguard's Health",
        hover = "Tweak Treeguard's Health to your liking!",
        options = {
			{ description = "Lowest (/4)", data = 750 },
			{ description = "Lowered (/2)", data = 1500 },			
            { description = "Default", data = 3000 },
            { description = "Higher (x1.5)", data = 4500 },
            { description = "Highest (x2)", data = 6000 },
            { description = "Uncomp (x3)", data = 9000 } },
        default = 3000
    },	
	{	
        name = "Twins of Terror's Health",
        label = "Twins of Terror's Health",
        hover = "Tweak Twins of Terror's Health to your liking!",
        options = {
			{ description = "Lowest (/4)", data =  0.25},
			{ description = "Lowered (/2)", data = 0.5 },			
            { description = "Default", data = 1 },
            { description = "Higher (x1.5)", data = 1.5 },
            { description = "Highest (x2)", data = 2 },
            { description = "Uncomp (x3)", data = 3 } },
        default = 1
    },	
	{	
        name = "Varg's Health",
        label = "Varg's Health",
        hover = "Tweak Varg's Health to your liking!",
        options = {
			{ description = "Lowest (/4)", data =  0.25},
			{ description = "Lowered (/2)", data = 0.5 },			
            { description = "Default", data = 1 },
            { description = "Higher (x1.5)", data = 1.5 },
            { description = "Highest (x2)", data = 2 },
            { description = "Uncomp (x3)", data = 3 } },
        default = 1
    },		
	{	
        name = "Wilting Dragonfly's Health",
        label = "Wilting Dragonfly's Health",
        hover = "Tweak Wilting Dragonfly's Health to your liking!",
        options = {
			{ description = "Lowest (/4)", data =  0.25},
			{ description = "Lowered (/2)", data = 0.5 },			
            { description = "Default", data = 1 },
            { description = "Higher (x1.5)", data = 1.5 },
            { description = "Highest (x2)", data = 2 },
            { description = "Uncomp (x3)", data = 3 } },
        default = 1
    },	

    --	BinaryConfig("crabking_claws", "Crabking Fight Adjustment", "The Crabkings imposing claws now deal 500 damage to the king when killed.", false),
    SkipSpace(),
    SkipSpace(),
    SkipSpace(),

    -----------------------------
    -- Experimental --
    -----------------------------
    Header("> Experimental <"),
    -----------------------------
    BinaryConfig("the_cooler_sacred_chest", "Ancient Chest Crafting Recipes",
        "Disable this if the Metheus puzzle in-game portion breaks. \nIt shouldn't, so please also file a bug report!",
        false),    
    BinaryConfig("winonawackycats", "Experimental Winona Catapults",
    "Catapults no longer regenerate, have reduced health, and deal 34 AOE damage.", false),	
    BinaryConfig("wolfgang", "Experimental Wolfgang",
    "Wolfgang gains mightiness based on hunger level. Hunger drain increases the longer mighty is maintained.", false),
    BinaryConfig("eyebrellarework", "Eyebrella Rework",
    "Eyebrella stats restored to Vanilla value, must be repaired with Milky Whites, 12 day durability. Isn't affected by clothing degradation.",
    false),        
    --	BinaryConfig("MutExt_beta", "Mutation Extrapolation", "Eyes to lie, mouthes to blind, skin to shed.", false),
    --	BinaryConfig("shiversprites_enabled", "Shiversprites", "Something new waits out in the frozen tundra.", false),
    SkipSpace(),

    -----------------------------
    -- Legacy Options --
    -----------------------------
    Header("> Legacy Options <"),
    -----------------------------
    BinaryConfig("hangyperds", "Starving Gobblers",
        "Gobblers are now more agressive and will attempt to take berries out of the player's inventory.", false),
    BinaryConfig("woodie_wet_goose", "Weregoose Wetness", "Weregoose gains wetness when over water.", false),
    BinaryConfig("cave_clops", "[BROKEN] Cave Deerclops",
        "During winter, Deerclops can break through the cave ceiling to reach you.", false),
    {
        name = "boss_resistance_",
        label = "[BROKEN] Dynamic Boss Res.",
        hover =
        "Some bosses have increasing resistance against multiple players",
        options = {
            {
                description = "Dynamic",
                hover = "Bosses change their resistance based on hits taken.",
                data = 1
            },
            {
                description = "Static",
                hover = "Bosses change their resistance based on nearby players.",
                data = 2
            },
            { description = "Disabled", data = 3 },
        },
        default = 3,
    },
    BinaryConfig("wormwood_fire", "[BROKEN] Extra Flamable Wormwood", "Wormwood is highly flameable, like in Hamlet.",
        false),	
    BinaryConfig("hayfever_disable", "[BROKEN] Hayfever",
        "Hayfever makes a return from Hamlet, but tweaked so it doesn't make you want to die. Prevent sneezing with antihistamines and certain hats.",
        false),	
    BinaryConfig("moon_transformations", "[BROKEN] Moon Transfor.",
        "Certain things transform under the dim light of the full \"Moon\".", false),
	SkipSpace(),
    -----------------------------
    -- Dev Tools --
    -----------------------------
    Header("> Dev Tools <"),
    -----------------------------
    BinaryConfig("announce_basestatus", "[DEV] Announce Ratsniffer",
        "[Developer Tool] Prints the exact rat sniff values to chat to be viewed in real time.", false),
    --	BinaryConfig("chartest_tools", "[DEV] Character Tools","[Developer Tool] Certain characters spawn with items that help test their mechanics.",false),
    SkipSpace(),

    -----------------------------
    -- Super Sekrit Settings --
    -----------------------------
    Header("> Super Sekrit Settings <"),
    -----------------------------
    Header("PROCEED WITH CARE"),
    Header("󰀊 ROLLBACK CITY 󰀊"),

    -- Hi data miners!
    -- I will not explain what's going on below!
    -- Mara =)

    --	Header("General"),
    BinaryConfig("um_shrink", "Don't Shrink", "Shrink when losing Health / Hunger, become flat when insane.", false),    
    BinaryConfig("um_advertisements", "Fun Mode", "Enables FUN new messages for an enhanced experience!", false),    
    BinaryConfig("maraboss_bottomtext", "JUDGEMENT", "Enables a particular lunar mutation. Yup!", false),

    --	BinaryConfig("boat_go_vroom", "Boat Tweak", "Allows greater player agency in directing boats.", false),
    --	BinaryConfig("self_combusting_traps", "Burningable Traps", "Back by unpopular demand! Conceptually expanded.", false),
    --	BinaryConfig("rat_arson", "Illegalize Rats", "Rats are now illegal. Please inform them of this.", false),
    SkipSpace()

    --	Header("Character Additions"),
    --	BinaryConfig("wigfrid_peak_performance", "Wigfrid Performance Buff", "Buffs Wigfrid's performance in general.", false),
    --	BinaryConfig("winky_eat_books", "Winky Books", "Winky can now eat books to obtain their(?) knowledge.", false),
    --	BinaryConfig("wathom_inhaler_real", "Wathom UnNerf", "Fixed Wathom's inhaler.", false),
    --	BinaryConfig("postthefunnytombstone", "Wathom Death Mode", "Made Wathom's death more impactful.", false),
    --	BinaryConfig("wixiegun_uno_reverse", "Wixie Gun", "For her neutral special...", false),
    --	BinaryConfig("hyuyu_that", "HyuYIRP", "Hyuyu is over. We finally did it.", false),
    --	BinaryConfig("wolfgang_commits_golf_emoji", "Golfwang", "SWOOSH", false),
    --	BinaryConfig("addedsupremecalamitas", "Added Supreme Calamitas", "Added Supreme Calamitas.", false),
    --	SkipSpace(),

    -----------------------------
    -- Secret Secret --
    -----------------------------
    --	Header("Secret Secret"),
    --	BinaryConfig("its_getting_hot_in_here", "The Hot Wind Blowing", " https://www.youtube.com/watch?v=fq3abPnEEGE ", false),
    --	SkipSpace(),
}
