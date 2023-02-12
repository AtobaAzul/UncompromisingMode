name = "󰀕 Uncompromising Mode"
description =
[[
󰀔 [ Version 1.5.1.8: "Calm Before the Storm" ]

Uncompromising Mode increases the risk and reward for those who have mastered Don't Starve Together.

Prominent features:
- Wathom, the Forgotten Parody
- Reworks to the Bee Queen and Ancient Guardian. New Vets Curse item from Bee Queen.
- New setpieces, and mysteries at sea.
- Reed Armor, Shark Suit Armor, Magnerang, Fishing Net, and much more!

󰀏 NEXT UPDATE: Under the Weather, Part I.]]

author = "󰀈 The Uncomp Dev Team 󰀈"

version = "Calm Before the Storm v1.5.1.8"

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

server_filter_tags = {
	"uncompromising",
	"DSTU",
	"collab",
	"overhaul",
	"hard",
	"difficult",
	"madness",
	"challenge",
	"hardcore"
}

priority = -10

------------------------------
-- local functions to makes things prettier

local function Header(title)
	return { name = "", label = title, hover = "", options = { {description = "", data = false}, }, default = false, }
end

local function SkipSpace()
	return { name = "", label = "", hover = "", options = { {description = "", data = false}, }, default = false, }
end

local function BinaryConfig(name, label, hover, default)
    return { name = name, label = label, hover = hover, options = { {description = "Enabled", data = true, hover = "Enabled."}, {description = "Disabled", data = false, hover = "Disabled."}, }, default = default, }
end
------------------------------

configuration_options =
{
------------------------------
-- Core Gameplay --
------------------------------
	--Header("Official Beta Compatibility"),
	--BinaryConfig("beta_compatibility", "March QoL Beta", "This will enable proper compatibility for the beta Crafting, Ancient Guardian, and Varg Waves features.", false),

	Header("Mod Compatibility"),
	BinaryConfig("worldgenmastertoggle", "Master Toggle", "Toggles ALL worldgen. MUST DISABLE IN ISLAND ADVENTURE WORLDS!", true),
	BinaryConfig("um_music", "Official Soundtrack", "Disable this if you are crashing when using client music mods.", true),
	BinaryConfig("hungry_void", "Anti-Voidwalk", "Disable this if you are using any mods that allow flight or traversal over the cave void.", true),
	SkipSpace(),

	Header("Core Gameplay"),
	BinaryConfig("foodregen", "Over Time Food Stats", "Health and Sanity from foods is applied over time, each food acting as a seperate stackable health or sanity regen buff.", true),
    BinaryConfig("caved", "[IMPORTANT] Cave Config", "Switches some things around so players who can't run Caves can still enjoy the game. ENABLE IF CAVES ARE ENABLED!", true),
	{
		name = "rne chance",
		label = "Night Terrors Chance",
		hover = "Night Terrors have a default 40% chance to occur each night. Night Terrors are disabled before Day 5.",
		options =
		{
			{description = "None", data = 100},
			{description = "10%", data = 0.9},
			{description = "20%", data = 0.8},
			{description = "30%", data = 0.7},
			{description = "40%", data = 0.6},
			{description = "50%", data = 0.5},
			{description = "60%", data = 0.4},
			{description = "70%", data = 0.3},
			{description = "80%", data = 0.2},
			{description = "90%", data = 0.1},
			{description = "INSANITY", data = 0},
		},
		default = 0.8,
	},
	BinaryConfig("compromising_vortex", "Non-lethal Shadow Vortex", "Shadow Vortex now teleports you to some random place.", false),
    BinaryConfig("harder_shadows", "Harder Nightmare Creatures", "Insanity is a big threat now. Those who pass the brink may never return.", true),
    BinaryConfig("rat_raids", "Rat Raids", "Rats will periodically be attracted to your base.", true),
    BinaryConfig("durability", "Clothing Degradation", "Winter and Rain protection clothing items become less effective when their durability drops.", false),
	BinaryConfig("sewingkit", "Sewing Kit Tweaks", "Sewing Kit has DOUBLE uses, but repairs HALF value. Pairs very well with Clothing Degredation, lets you keep clothing in top shape more easily.", true),
	BinaryConfig("lifeamulet", "Life Giving Amulet Changes", "The Life Giving Amulet acts like vanilla Don't Starve, only reviving when worn upon death. \nIts hunger > health conversion ticks much faster.", true),
	BinaryConfig("longpig", "Long Pig", "Skeletons drop Long Pig to prevent telltale heart spam.", true),
	{
		name = "flingo_setting",
		label = "Flingomatic Nerf",
		hover = "Pick the flingomatic nerf you would like to play around.",
		options =
		{
			{description = "Fuel loss in use", data = "Fuelmuncher"},
			{description = "No longer freezes", data = "Waterballs"},
			{description = "None", data = "Newb"},
		},
		default = "Waterballs",
	},

	{
		name = "fireloot",
		label = "Burning Loot Drop Rework",
		hover = "Loot no longer gets destroyed when a mob is burnt to death. Mobs will explode on death, dealing damage and lightning things on fire, based on loot dropped.",
		options =
		{
			{description = "Off", data = 1},
			{description = "Explosion Off", data = 2},
			{description = "Explosion On", data = 3},
		},
		default = 3,
	},
	{
		name = "vetcurse",
		label = "Veteran's Curse",
		hover = "Veteran's curse is an optional difficulty  mode, which increases risk & reward.",
		options =
		{
			{description = "Default", data = "default"},
			{description = "Always On", data = "always"},
			{description = "Off", data = "off"},
		},
		default = "default",
	},
	BinaryConfig("moon_transformations", "Moon Transformations","Certain things transform under the dim light of the full \"Moon\".", false),
	BinaryConfig("worldregrowth", "World Regrowth", "Governs whether world, desolation and resource regrowths function.", false),
	SkipSpace(),
------------------------------
-- Character Reworks --
------------------------------
    Header("Characters"),
------------------------------
	BinaryConfig("funny rat", "Winky", "Enable Uncompromising Mode's Winky, the Vile Vermin.", true),
	BinaryConfig("holy fucking shit it's wathom", "Wathom", "Enable Uncompromising Mode's Wathom, the Abomination.", true),
	BinaryConfig("wathom_maxdmg", "Wathom: Damage Cap", "Wathom's damage is capped at 600 to limit his absurd burst damage potential.", true),
	{
		name = "wathom_ampvulnerability",
		label = "Wathom: Amped Vulnerability",
		hover = "Wathom takes more damage when amped.",
		options =
		{
			{description = "5x (Default)", data = 5},
			{description = "4x", data = 4},
			{description = "3x", data = 3},
			{description = "2x", data = 2},
		},
		default = 5,
	},
	{
		name = "wathom_armordamage",
		label = "Wathom: Armor Damage Priority",
		hover = "Wathom can take increased damage, choose if armor damage is ignored.",
		options =
		{
			{description = "Include Armor", data = true, hover = "Wathom multiplies incoming damage by the current damage multiplier"},
			{description = "Don't include armor", data = false, hover = "Wathom multiplies resulting damage by the current damage multiplier."},
		},
		default = true,
	},
	BinaryConfig("willow", "Willow", "Willow's Lighter now lasts forever when she holds it, she will retaliate when attacked by shadows.", true),
	BinaryConfig("bernie_buffs", "Willow: Bernie Buffs", "Bernie has 80% resistance against shadows\nHolding bernie prevents shadows from aggro'ing.", true),
    BinaryConfig("warly", "Warly", "Warly gets increased stats from food, like Singleplayer. However, he remembers foods for 3 days instead of 2.", true),
	BinaryConfig("waxwell", "Maxwell", "Maxwell gets buffed versions of his classic shadows by reading the Codex Umbra. Disable for Maxwell mod compatibility!", true),
	--BinaryConfig("wolfgang", "Improved/Balanced Wolfgang", "Wolfgang gains new perks and downsides. Read the patch notes included in the mod folder or workshop for details.", false),
	BinaryConfig("wigfrid", "Wigfrid", "Reduced Wigfrids combat leeching effect to more balanced levels.", true),
	BinaryConfig("wolfgang", "Experimental Wolfgang", "Wolfgang gains mightiness based on hunger level. Hunger drain increases the longer mighty is maintained.", false),
	BinaryConfig("winonaworker", "Winona: Faster Working", "Winona now scales her work/picking efficiency, and tool/weapon durability, off of her hunger level. Drains hunger when taking actions.", true),
	BinaryConfig("winonawackycats", "Experimental Winona Catapults", "Catapults no longer regenerate, have reduced health, and 34 AOE damage.", false),
	BinaryConfig("winona_gen", "Winona: Generators", "Limits access to Winona's Generators to only allow her to use them", true),
		{
		name = "wortox",
		label = "UM Wortox",
		hover = "Wortox has different settings that change his characteristics.",
		options =
		{
			{description = "SHOT", data = "SHOT", hover = "Souls heal over time."},
			{description = "Classic", data = "UMNERF", hover = "Less soul sources, less max health."},
			{description = "Vanilla", data = "off"},
		},
		default = "UMNERF",
	},
	BinaryConfig("wickerbottom", "Wickerbottom: Sane Reading", "Wickerbottom/Maxwell can no longer read books while insane.", true),
	BinaryConfig("on tentacles", "Wickerbottom: On Tentacles", "On Tentacles now spawns friendly tentacles that die over time, and do not drop tentacle spots.", true),
	BinaryConfig("applied horticulture", "Wickerbottom: Horticulture", "\"Horticulture, Abridged\" now takes 1 Leafy Meat instead of 5 seeds, to better balance it from being too easily spammable early game.", true),
	BinaryConfig("book_recipes", "Wickerbottom: Book Recipe Tweaks", "Changes some book recipes to be slightly more balanced.", true),
	BinaryConfig("wanda_nerf", "Wanda:", "A bunch of changes to some of Wanda's more overpowered items to make them more balanced.", true),
	BinaryConfig("wormwood_extrafiredmg", "Wormwood: Extra Fire Damage", "Increases Wormwood's fire damage multiplier to 1.75x, from 1.25x", true),
	BinaryConfig("wormwood_plants", "Wormwood: Planting Sanity", "Increases the sanity loss from digging plants.", true),
	BinaryConfig("wendy", "Wendy", "Abigail was nerfed to not increase Wendy's maximum damage above average.", true),
	BinaryConfig("wx78", "WX-78", "No longer heals from lightning", true),
	SkipSpace(),
------------------------------
-- Weather --
------------------------------
    Header("Weather"),
------------------------------
	{
		name = "weatherhazard_autumn",
		label = "Start Date for Autumn weather",
		hover = "New autumn weather occurs in the second year by default.\nThis currently only includes poisonous frogs.",
		options =
		{
			{description = "First Year", data = 5}, --lowered in case someone has a diff starting season, or wants to suffer.
			{description = "Second Year", data = 70},
			{description = "Third Year", data = 120}, --idk math yell at me if wrong
		},
		default = 70,
	},
	{
		name = "weatherhazard_winter",
		label = "Start Date for Winter weather",
		hover = "New winter weather occurs in the first year by default",
		options =
		{
			{description = "First Year", data = 5},
			{description = "Second Year", data = 70},
			{description = "Third Year", data = 120},
		},
		default = 5,
	},
	{
		name = "weatherhazard_spring",
		label = "Start Date for Spring weather",
		hover = "New spring weather occurs in the first year, by default.",
		options =
		{
			{description = "First Year", data = 5},
			{description = "Second Year", data = 70},
			{description = "Third Year", data = 120},
		},
		default = 5,
	},
--[[{
	name = "weatherhazard_summer",
	label = "Start Date for new Spring weather",
	hover = "New spring weather occurs in the first year, by default.",
	options =
	{
		{description = "First Year", data = 22},
		{description = "Second Year", data = 70},
		{description = "Third Year", data = 120},
	},
	default = 22,
	},]]
    BinaryConfig("snowstorms", "Snowstorms", "Snowtorms impede on players' speed and vision if they are not wearing eye protection. Snowstorms also causes snow to build up on structures.", true),
    BinaryConfig("hayfever", "Hayfever", "Hayfever makes a return from Hamlet, but tweaked so it doesn't make you want to die. Prevent sneezing with antihistamines and certain hats.", false),
    BinaryConfig("winter_burning", "Harder Burning", "Winter makes it so setting stuff alight takes more time, and also finish burning faster.", true),
	--BinaryConfig("acidrain", "Acid Rain", "After the First Year, Toadstool will grow poisionous mushtrees aboveground and pollute the world, making the rain acidic.", true),
	BinaryConfig("hotcaves", "Hotter Caves", "During summer, caves are just hot enough to heat you without any gear.", true),
	--[[Header("Gamemode"),
	{
		name = "gamemode",
		label = "Mode",
		hover = "Currently, there are no other modes. Yet.", --"Choose gamemode. 1) Original Uncompromising version (default settings). 2) Mod is enabled after first Fuelweaver is defeated. 3) Choose custom settings.",
		options =
		{
			{description = "Uncompromising", data = 0}, -- TODO: When this is selected, disable the below ones (gray them out)
			--{description = "Custom", data = 2}, --TODO: On custom, enable editing the below settings
		},
		default = 0,
	},]]

	SkipSpace(),
	Header("World Gen"),
	BinaryConfig("hoodedforest", "Hooded Forest", "Hooded Forest replaces the Moon Base forest, with brand new things to explore, including a new boss!", true),
	{
		name = "ghostwalrus",
		label = "Rusty Traps",
		hover = "Mac tusk forgot to pick up some traps and left them to rust.",
		options = 
		{
			{description = "Enabled", data = "enabled"},
			{description = "Enabled (No Respawn)", data = "norespawn", hover = "Traps don't respawn over time."},
			{description = "Disabled", data = "disabled"},
		},
		default = "enabled",
	},
	BinaryConfig("rice","Rice","Rice spawns in ponds in the swamp.", true),
	BinaryConfig("trapdoorspiders", "Trapdoor Spiders", "Enables the spawn of trapdoor spider mounds on worldgen. Their dens are usually covered in a resource rich grass.", true),
	SkipSpace(),
------------------------------
-- Character Reworks --
------------------------------
    Header("Rats"),
------------------------------
    {
		name = "ratgrace",
		label = "Rat Raid Grace Period",
		hover = "Minimum grace period that makes rats unable to invade!",
		options =
		{
			{description = "As soon as possible.", data = 1},
			{description = "Low[15 days]", data = 15},
			{description = "Default[30 days]", data = 30},
			{description = "Medium[45 days]", data = 45},
			{description = "High[60 days]", data = 60},
		},
		default = 30,
	},
    {
		name = "rattimer",
		label = "Rat Raid Cooldown",
		hover = "The cooldown between rat raids!",
		options =
		{
			{description = "As soon as possible.", data = 10},
			{description = "Half", data = 4800},
			{description = "Default", data = 9600},
			{description = "Double", data = 14400},
		},
		default = 9600,
	},
	{
		name = "ratsnifftimer_",
		label = "Rat Sniff Timer",
		hover = "The rate at which your base is checked for messiness.",
		options =
		{
			{description = "Lowest[1 Minute]", data = 60},
			{description = "Lowered[2 Minutes]", data = 120},
			{description = "Default[3 Minutes]", data = 180},
			{description = "Raised[4 Minutes]", data = 240},
			{description = "Extended[8 Minutes]", data = 480}
		},
		default = 180,
	},
	BinaryConfig("itemcheck", "Item Score", "Equippable items and mole bait items increase the \'rat score\' value.", true),
-----------------------------
-- Items and Structures--
-----------------------------
	SkipSpace(),
	Header("Items and Structures"),
	BinaryConfig("telestaff_rework", "Telelocator Rework", "You can now select Focus you want to teleport to. Focuses now cost 3 Purple gems instead of gold.\nStaff's uses doubled.", true),
	BinaryConfig("no4crafts", "No 4-Ingredient Recipes", "Changes all 4-ingredient recipes to use 3 instead.", false),
	BinaryConfig("scaledchestbuff", "Scaled Chest Buff", "Scaled chest is not worth the resources required. Enabling this buffs it to 25 slots. Toggling with scaled chests in existing world may cause crash.", true),
	BinaryConfig("scalemailbuff", "Scalemail Buff", "Scalemail now spawns 3 Dimvaes to help you in combat", true),
	BinaryConfig("canedurability", "Cane Durability (Off by default)", "Cane loses durability similarly to a whirly fan, note that UM walruses drop tusks 100% of the time with this on.", false),

	{
		name = "gotobed",
		label = "Sleeping Buff",
		hover = "Sleeping can heal max health loss. Siesta Lean-to hunger drain is now 50% of a Tent, instead of 33%.",
		options =
		{
			{description = "Default", data = "default", hover= "Only heal max health loss if BELOW 25%."},
			{description = "Legacy", data = "legacy", hover = "Heal max health lost regardless of %."},
			{description = "Disabled", data = false},
		},
		default = "default",
	},
	BinaryConfig("passibleimpassibles", "Remove Cheese-able Collisions", "Removes collision from stuff such as statues to prevent cheese.", true),
	{
		name = "sleepingbuff",
		label = "Sleeping Stat Speed",
		hover = "Increases the speed at which sleeping gives stats/drains hunger. Default 1.5x",
		options =
		{
			{description = "2x Faster", data = 2},
			{description = "1.5x Faster", data = 1.5},
			{description = "Vanilla", data = 1},
		},
		default = 1.5,
	},
	{
		name = "pocket_powertrip",
		label = "Clothing Pockets",
		hover = "Gives some underused dress items pockets.",
		options =
		{
			{description = "On", data = 1},
			{description = "On (Backpack-like)", data = 2, hover = "Items with pockets act like backpacks. Can't be put in inventory."},
			{description = "Off", data = 0},
		},
		default = 1,
	},
	BinaryConfig("insul_thermalstone", "Tweaked Thermal Stone", "Thermal stones now have less insulation, but inherit some insulation from clothing.", true),
	BinaryConfig("uncool_chester", "Thermal Stone Snow Chester Nerf", "Snow Chester will no longer freeze Thermal Stones.", true),
	{
		name = "electricalmishap",
		label = "Electrical Weapon Retune",
		hover = "Controls how electrical weapons (Bug Zapper and Morning Star) behaves.",
		options =
		{
			{description = "Electrical Mishap", data = 1, hover = "Weapons can be charged from lightning and generators."},
			{description = "Classic", data = 2, hover = "Weapons can be refueled with some items. Bug Zapper drains over time." },
			{description = "Off", data = 0},
		},
		default = 1,
	},
	BinaryConfig("hambatnerf", "Ham Bat Nerf", "Spoils faster and minimum damage is lower.", true),
-----------------------------
-- Food --
-----------------------------
	SkipSpace(),
	Header("Food"),
	Header("Crockpot Recipes"),
	BinaryConfig("nowintergrowing", "No Winter Growing", "Makes a few food sources such as kelp and stone fruit not grow in winter", true),
	BinaryConfig("newrecipes", "New Recipes", "UM adds a few new recipes\nTurn this off if you're using mods that can cause overlap, such as HoF.", true),
	BinaryConfig("crockpotmonstmeat", "Harder Monster Meat", "Enables the new monster lagsana recipe, where you can only make recipes if the meat value is greater than monster value.", true),
	BinaryConfig("generalcrockblocker", "Trash Filler Blocker", "Heavy use of certain low quality crockpot ingredients, such as twigs, ice, buttefly wings, and other inedibles results in wet goop.", true),
	BinaryConfig("icecrockblocker", "Snowcones", "Snowcones prevent heavy use of ice specifically in crockpot dishes that don't call for it.", true),

	SkipSpace(),
	Header("Crockpot Food Tweaks"),
	BinaryConfig("meatball", "Meatball Nerf", "Meatballs restore 50 hunger instead of 62.5.", true),
	{
		name = "perogi",
		label = "Pierogi Recipe Nerf",
		hover = "Pierogis require more veggies to cook",
		options =
		{
			{description = "1.5 Veggie Value", data = 1.5},
			{description = "2 Veggie Value", data = 2},
			{description = "1 Veggie Value", data = 1},
			{description = "Vanilla Value", data = 0.5},
		},
		default = 1.5,
	},
	BinaryConfig("buttmuffin", "Butter Muffin Buff", "Butter muffin restores 30 health 10 sanity instead of 20 health 5 sanity.", true),
	BinaryConfig("icecreambuff", "Ice Cream Buff", "Ice Cream now restores 100 sanity, but does it slowly.", true),
	BinaryConfig("farmfoodredux", "Farmplot Food Redux", "Reallocates most dishes that involve crockpot foods. Typically a buff, but may exchange some stats.", true),
	BinaryConfig("sr_foodrebalance", "Fish foods rebalance", "Several fish based foods have their stats tweaked.", true),
	SkipSpace(),
	Header("General Food Tweaks"),
	BinaryConfig("beebox_nerf", "Bee Box Nerf", "Bee boxes only release 2 bees max.", true),
	{
		name = "more perishing",
		label = "Increased Food Spoilage",
		hover = "Food spoils faster. It's as simple as that.",
		options =
		{
			{description = "Disabled(1x)", data = 1},
			{description = "1.5x", data = 1.5},
			{description = "2x", data = 2},
			{description = "2.5x", data = 2.5},
			{description = "3x", data = 3},
		},
		default = 1.5,
	},
	BinaryConfig("butterflywings_nerf", "Weaker Butterfly Wings", "Butterfly wings have been nerfed to not be cheap healing", true),
	BinaryConfig("rawcropsnerf", "Raw Crops Nerf", "Farm crops are nerfed in their base value when raw/cooked to incentivize using crockpot recipes.", true),
	BinaryConfig("seeds", "Lowered Seeds Hunger", "Seeds have had their hunger lowered.", true),
	{
		name = "monstereggs",
		label = "Monster Eggs",
		hover = "Birds now give monster eggs when fed monster meats.\nMonster eggs are like eggs, but have configurable monster value.",
		options =
		{
			{description = "Off", data = 0},
			{description = "0.25 Monster", data = 0.25},
			{description = "0.5 Monster", data = 0.5},
			{description = "1 Monster", data = 1},
			{description = "1.5 Monster", data = 1.5},
		},
		default = 1,
	},
-----------------------------
-- Monsters --
-----------------------------
	SkipSpace(),
	Header("Monsters"),

	Header("New Hounds"),
	BinaryConfig("lightninghounds", "Lightning Hounds", "Lightning Hounds are part of hound waves.", true),
	BinaryConfig("magmahounds", "Magma Hounds", "Magma Hounds are part of hound waves.", true),
	BinaryConfig("sporehounds", "Spore Hounds", "Spore Hounds are part of hound waves.", true),
	BinaryConfig("glacialhounds", "Glacial Hounds", "Glacial Hounds are part of hound waves.", true),
	SkipSpace(),

	Header("Harder Hounds"),
	BinaryConfig("firebitehounds", "Fiery Bite", "Red Hounds set players on fire when they attack.", true),
	BinaryConfig("frostbitehounds", "Frozen Bite", "Blue Hounds freeze players when they attack.", true),
	SkipSpace(),

	Header("Wave Changes"),
	BinaryConfig("lategamehoundspread", "Decreased Lategame Frequency", "Enabling this decreases the frequency in the lategame so hounds are still a threat, but not annoying.", true),

	--[[BinaryConfig("vargwaves", "Vargs in Hound Waves", "In the lategame, vargs will accompany hounds in houndwaves.", true),
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
	},]]

	SkipSpace(),
	Header("New Depths Worms"),
	BinaryConfig("depthseels", "Depths Eels", "Electrified depths eels join the worm pack in Winter and Spring.", true),
	BinaryConfig("depthsvipers", "Depths Vipers", "Mysterious depths vipers join the worm pack in Summer and Autumn", true),

	SkipSpace(),
	Header("Bats"),
	BinaryConfig("hardbatilisks", "Harder Batilisks", "Batilisk's health is increased from 50 to 75, drop wings less often than vanilla, drop monster morsels.", true),
	BinaryConfig("adultbatilisks", "Adult Batilisks", "Adult Batilisks spawn under certain conditions instead of regular ones. They are harder, but have better loot on average.", true),
	BinaryConfig("batspooking", "Bat Sinkhole Evacuation", "Sinkholes will spawn all of their bats as soon as they are regenerated, instead of slowly trickling out.", true),
	SkipSpace(),

	Header("Spiders"),
	BinaryConfig("alljumperspiders", "Regular Spiders Jump", "Normal spiders leap, just like spider warriors.", true),
	BinaryConfig("spiderwarriorcounter", "Warrior Counter", "Warrior spiders (and depth dwellers) perform a counter-attack when attacked (also lowers health to 300).", true),
	SkipSpace(),

	Header("New Ruins Monsters"),
	BinaryConfig("trepidations", "Ancient Trepidations", "Enabling this allows trepidations to roam the halls of the ruins, seeking out the weak of mind.", true),
	BinaryConfig("pawns", "Clockwork Pawns", "Enabling this allows pawns to patrol the depths of the caves, drawing unwanted attention to the foolish and lost.", true),
	BinaryConfig("amalgams", "Clockwork Amalgams", "Enabling this allows pawns and clockwork piles to spawn Comingled Clockworks", true),
	SkipSpace(),


	Header("Misc Monsters"),
	BinaryConfig("pigking_guards", "Pig King Guards", "Pig King now has neutral guards watching over any suspicious activity.", true),
	BinaryConfig("bushcrabs", "Bush Crabs", "Bush Crabs ambush the player when digging berry bushes...", true),
	BinaryConfig("desertscorpions", "Scorpions", "Scorpions plague the desert lands. They will spawn from desert turf within the desert during the day.", true),
	BinaryConfig("pinelings", "Pinelings", "Stumps will become pinelings if awoken by a treeguard, or can happen naturally to existing old stumps.", true),
	BinaryConfig("pollenmites", "Pollen Mites", "Pollen mites spawn in spring and quickly infest the nearby area.", false),
	BinaryConfig("maxhphitters", "Max HP Damage", "Some monsters deal Max HP damage\nTurn this off if you're having problems with mods which also interact with it.", true),
	BinaryConfig("harder_krampus", "Harder Krampus", "Krampii now have a new attack with knockback.", true),
	BinaryConfig("noauradamage_butterfly", "AoE Immune Butterflies", "Butterflies are immune to AoE damage such as catapults, and Abigail.", true),
	SkipSpace(),

	Header("Standard Creatures"),
	BinaryConfig("angrypenguins", "Territorial Penguins","Penguins will aggresively defend their land.", true),
	BinaryConfig("harder_pigs", "Harder Pigs","Pigs have  a new counter and charge attack.", true),
	BinaryConfig("angry_werepigs", "Angry Werepigs", "Werepigs prioritize attacking over eating.", true),
	BinaryConfig("harder_walrus","Harder MacTusk","Mactusk has a counter attack and can throw traps.", true),
	BinaryConfig("harder_beefalo","Harder Beefalo","Beefalo ocasionally charge after a telegraph.", true),
	BinaryConfig("harder_koalefants", "Harder Koalefants", "Koalefants have brand new attacks and doubled health", true),
	BinaryConfig("hungryfrogs", "Hungry Frogs", "Frogs eat anything left on the floor.", true),
	BinaryConfig("cowardfrogs", "Frog Anti-cheese", "Frogs flee from bosses to prevent cheesing.", true),
	BinaryConfig("toads", "Toads", "Toads replace frogs in the second autumn and release poisonous clouds on death.", true),
	BinaryConfig("fiendforcedmetodothis", "Slurtle Tweaks", "Slurtles attack faster, have less health and drop Shellmets more often.", true),
	SkipSpace(),

-----------------------------
-- Bosses --
-----------------------------
	Header("Bosses"),
	Header("Additional Seasonal Giants"),
	BinaryConfig("mother_goose", "Mother Goose", "Mother Goose will now attack the player in spring, similar to the Reign of Giant's Moose.", true),
	{
		name = "mother_goose_spawn",
		label = "Mother Goose Spawn Date",
		hover = "The year that Mother Goose can spawn.",
		options = 
		{
			{description = "Year 1 (Default)", data = 26},
			{description = "Year 2", data = 26*1.5},--maybe???
			{description = "Year 3", data = 26*2.5}--???
		},
		default = 26,
	},
	BinaryConfig("wiltfly", "Wilting Dragonfly", "Dragonfly will now leave her arena during summer and attack the player, similar to Reign of Giant's Dragonfly.", true),
	{
		name = "wiltfly_spawn",
		label = "Wilting Dragonfly Spawn Date",
		hover = "The year that Wilting Dragonfly can spawn.",
		options = 
		{
			{description = "Year 1 (Default)", data = 26},
			{description = "Year 2", data = 26*2},--maybe???
			{description = "Year 3", data = 26*3}--???
		},
		default = 26,
	},
	SkipSpace(),

	Header("Giants & Bosses"),
	BinaryConfig("harder_spiderqueen","Harder Spider Queen", "Spider Queen ocasionally spits web balls that trap players.", true),
	BinaryConfig("harder_deerclops", "Deerclops Mutations", "Three different harder versions of deerclops spawn instead of the vanilla variant.", true),
	BinaryConfig("caveclops","Cave Deerclops", "During winter, Deerclops can break through the cealing to reach you.", true),
	BinaryConfig("harder_moose", "Harder Goose", "Goose fight has more mechanics and is harder. This also disables Moose AOE. Does not apply to Mother Goose.", true),
	BinaryConfig("harder_bearger", "Harder Bearger", "Enabling this option makes bearger's fight contain more attacks, and will make bearger more actively seek out you.", true),
	BinaryConfig("harder_leifs", "Harder Treeguards", "Enabling this option makes treeguards perform root attacks, inflict knockback, and summon pinelings.", true),
	SkipSpace(),

	Header("Raid Bosses"),
	BinaryConfig("harder_dragonfly", "Harder Dragonfly", "Dragonfly now has knockback on hit.", true),
	BinaryConfig("harder_lavae", "Exploding Lavae", "Lavae will now leave exploding paste upon death, knocks holes in walls.", true),
	BinaryConfig("harder_beequeen", "Harder Bee Queen", "Bee Queen now has a variety of attacks with different bees.", true),--lame! help!
	BinaryConfig("rework_minotaur", "Ancient Guardian Rework", "The Ancient Guardian's fight is expanded, includes more attacks.", true),
	BinaryConfig("reworked_eyes", "Reworked Eyes of Terror", "Eye of Terror and the Twins have new attacks, inspired by their Terraria counterparts.", true),
	SkipSpace(),

	Header("Boss Quality of Life"),
    {
		name = "toadstool health",
		label = "Toadstool Health",
		hover = "Killing Toadstool stops acid rain from occuring. His health can be lowered to make a solo player's life easier.",
		options =
		{
			{description = "Default[52500]", data = 52500},
			{description = "Lowered[25000]", data = 25000},
			{description = "Lowest [17500]", data = 17500},
		},
		default = 52500,
	},
	{
		name = "bee queen health",
		label = "Bee Queen Health",
		hover = "Killing Bee Queen stops Hay Fever from occuring. Her health can be lowered to make a solo player's life easier.",
		options =
		{
			{description = "Default[22500]", data = 22500},
			{description = "Lowered[15000]", data = 15000},
			{description = "Lowest[10000]", data = 10000},
		},
		default = 22500,
	},
	{
		name = "widow health",
		label = "Hooded Widow Health",
		hover = "Hooded Widow's health can be lowered to closer match a singleplayer experience.",
		options =
		{
			{description = "Default[8000]", data = 8000},
			{description = "Lowered[6000]", data = 6000},
			{description = "Lowest[4000]", data = 4000},
		},
		default = 8000,
	},
	{
		name = "mother goose health",
		label = "Mother Goose Health",
		hover = "Mother Goose's health can be lowered to closer match a singleplayer experience.",
		options =
		{
			{description = "Pre-Nerf[8000]", data = 8000},
			{description = "Default[7000]", data = 7000},
			{description = "Lowered[6000]", data = 6000}, --Slightly lower than widow, not a raid boss
			{description = "Lowest[4000]", data = 4000},
		},
		default = 7000,
	},
	{
		name = "wiltfly health",
		label = "Wilting Dragonfly Health",
		hover = "Wilting Dragonfly's health can be lowered to closer match a singleplayer experience.",
		options =
		{
			{description = "Default[4000]", data = 4000},
			{description = "Lowered[3000]", data = 3000},
		},
		default = 4000,
	},
	{
		name = "twins health",
		label = "Twins of Terror Health",
		hover = "Twins of Terror's health can be lowered to closer match a singleplayer experience.",
		options =
		{
			{description = "Default[10000]", data = 10000},
			{description = "Lowered[7500]", data = 7500},
			{description = "Lowest[5000]", data = 5000},
		},
		default = 10000,
	},
	BinaryConfig("crabking_claws", "Crabking Fight Adjustment", "The Crabkings imposing claws now deal 500 damage to the king when killed.", false),
	SkipSpace(),
	
	Header("Experimental"),
	BinaryConfig("beefalo_nerf", "Beefalo Nerf", "Beefalo take half of the damage taken, instead of all.", false),
	BinaryConfig("announce_basestatus", "[DEV] Announce Ratsniffer","[Developer Tool] Prints the exact rat sniff values to chat to be viewed in real time.",false),
	BinaryConfig("eyebrellarework", "Eyebrella Rework","Eyebrella stats restored to vanilla value, must be repaired with Milky Whites, 12 day durability. Isn't affected by clothing degradation.",false),
	BinaryConfig("cooldown_orangestaff", "Cooldown Based Lazy Explorer", "Lazy explorer no longer has durabilty, but instead has cooldown, like Wanda's watches.\nSuggested by Lux.", false),
	SkipSpace(),
	Header("Legacy Options"),
	SkipSpace(),
	BinaryConfig("honeybandbuff", "Honey Poultice Buff", "[Experimental] Crafting honey poultice gives 2, healing with it gives 10 health overtime as well as 30 health.", false),
	BinaryConfig("woodie", "Weregoose Wetness", "Weregoose gains wetness when over water.", false),
	BinaryConfig("wormwood_fire", "Extra Flamable Wormwood", "Wormwood is highly flameable, like in Hamlet.", false),
	BinaryConfig("hangyperds", "Starving Gobblers", "Gobblers are now more agressive and will attempt to take berries out of the player's inventory.", false),
    BinaryConfig("bernie", "Big Bernie", "Enable Big BERNIE!!", true),

	------------------------------
-- Secret --
-------------------------------
    --Header("Secret"),
------------------------------

}