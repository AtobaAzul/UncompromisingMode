name = "[DEV] 󰀕 Uncompromising Mode"
description = 
[[
󰀔 [ Version 1.1.5 : "The Hooded Forest" ]

Uncompromising Mode increases the risk and reward for those who have mastered Don't Starve Together.

Prominent features:
- Rebalances and tweaks to nearly everything
- Random Night Events
- New seasonal weather events
- A new overworld biome
- Character tweaks and rebalances
- More nightmare creatures
- A bunch of new mobs, items, and bosses

󰀏 NEXT UPDATE: The Combat Update, which overhauls day-to-day fighting.]]

author = "󰀈 The Uncomp Dev Team 󰀈"

version = "1.1.5"

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
    return { name = name, label = label, hover = hover, options = { {description = "Enabled", data = true}, {description = "Disabled", data = false}, }, default = default, }
end
------------------------------

configuration_options =
{
------------------------------
-- Core Gameplay --
------------------------------
    Header("Core Gameplay"),
	BinaryConfig("foodregen", "Over Time Food Stats", "Health and Sanity from foods is applied over time, each food acting as a unique stackable buff.", true),
    BinaryConfig("caved", "[IMPORTANT] Cave Config", "Switches some things around so players who can't run Caves can still enjoy the game. ENABLE IF CAVES ARE ENABLED!", true),
	{
		name = "rne chance",
		label = "RNE Chance",
		hover = "Random Night Events have a default 40% chance to occur each night. RNEs are disabled before Day 5.",
		options =
		{
			{description = "None", data = 100},
			{description = "20%", data = 0.8},
			{description = "40%", data = 0.6},
			{description = "60%", data = 0.4},
			{description = "80%", data = 0.2},
			{description = "INSANITY", data = 0},
		},
		default = 0.6,
	},
    BinaryConfig("harder_shadows", "Harder Nightmare Creatures", "Insanity is a big threat now. Those who pass the brink may never return.", true),
    BinaryConfig("rat_raids", "Rat Raids", "Rats will periodically be attracted to your base.", true),
    BinaryConfig("durability", "Clothing Degradation", "Certain clothing items become less effective when their durability drops.", true),
    {
		name = "toadstool health",
		label = "Toadstool Health",
		hover = "Killing Toadstool stops acid rain from occuring. His health can be lowered to make a solo player's life easier.",
		options =
		{
			{description = "Default[52500]", data = 52500},
			{description = "Lowered[25000]", data = 25000},
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
		},
		default = 22500,
	},

	BinaryConfig("lifeamulet", "Life Giving Amulet Changes", "The Life Giving Amulet acts like vanilla Don't Starve, only reviving when worn upon death. \nIts hunger > health conversion ticks much faster.", true),
    
------------------------------
-- Character Reworks --
------------------------------
    Header("Character Reworks"),
------------------------------
    BinaryConfig("willow", "Willow Rework", "Willow's Lighter now has infinite durability, Willow can cast explosions, etc.", true),
    BinaryConfig("bernie", "Big Bernie", "Enable Big BERNIE!!", true),
    BinaryConfig("warly", "Improved Warly", "Warly gets increased stats from food, like Singleplayer. However, he remembers foods for 3 days instead of 2.", true),
	BinaryConfig("wolfgang", "Improved/Balanced Wolfgang", "Wolfgang gains new perks and downsides. Read the patch notes included in the mod folder or workshop for details.", true),


------------------------------
-- Weather --
------------------------------
    Header("Weather"),
------------------------------
	{
		name = "weather start date",
		label = "Start Date for New Weather.",
		hover = "The new weather events will easily topple players who aren't prepared. They occur on the first year by default.",
		options =
		{
			{description = "First Year", data = 22},
			{description = "Second Year", data = 55},
		},
		default = 22,
	},
    BinaryConfig("snowstorms", "Snowstorms", "Snowtorms impede on players' speed and vision if they are not wearing eye protection. Snowstorms also causes snow to build up on structures.", true),
    BinaryConfig("hayfever", "Hayfever", "Hayfever makes a return from Hamlet, but tweaked so it doesn't make you want to die. Prevent sneezing with antihistamines and certain hats.", true),
    --BinaryConfig("acidrain", "Acid Rain", "After the First Year, Toadstool will grow poisionous mushtrees aboveground and pollute the world, making the rain acidic.", true),
	
	Header("Gamemode"),
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
	},
	
	
------------------------------
-- Secret --
------------------------------
    Header("Secret"),
------------------------------
BinaryConfig("crabking_claws", "Crabking Fight Adjustment", "The Crabkings imposing claws now deal 500 damage to the king when killed", false),
    
}