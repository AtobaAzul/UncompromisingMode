name = "[DEV] 󰀕 Uncompromising Mode"
description = 
[[
󰀔 [ Version 1.1.5 : "The Hooded Forest" ]
Uncompromising Mode increases the risk and reward for those who have mastered Don't Starve Together.

Prominent features:
- Random Night Events
- Rebalances and tweaks to nearly everything
- New weather, like snowstorms and acid rain
- A new overworld biome
- Character tweaks and rebalances
- More insanity monsters
- A bunch of new mobs, items, and bosses
󰀏 NEXT UPDATE: The Combat Update, which overhauls day-to-day fighting.

(Check out the configuration options below!)]]

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

priority = 10

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
    BinaryConfig("caveless", "[IMPORTANT] CAVES", "ENABLE IF YOU HAVE CAVES ENABLED, VISE VERSA. \n>VERY< IMPORTANT.", true),
	{
		name = "rne chance",
		label = "Random Night Event Chance",
		hover = "Remember: Too much of a good thing is a bad thing! \n(Increases by 10% per extra player)",
		options =
		{
			{description = "None", data = 100},
			{description = "20%", data = 0.9},
			{description = "40%", data = 0.7},
			{description = "60%", data = 0.5},
			{description = "80%", data = 0.3},
			{description = "INSANITY", data = 0},
		},
		default = 0.7,
	},
    BinaryConfig("harder_shadows", "Harder Nightmare Creatures", "New troubles rest within your mind.", true),
    BinaryConfig("rat_raids", "Rat Raids", "Your base will be raided by rats.", true),
    BinaryConfig("durability", "Clothing Degradation", "Certain clothing items are less effective the lower their durability.", true),
    {
		name = "toadstool health",
		label = "Toadstool Health",
		hover = "The Toadstool now affects survival, this is mostly for solo play.",
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
		hover = "The Bee Queen now affects survival, this is mostly for solo play.",
		options =
		{
			{description = "Default[22500]", data = 22500},
			{description = "Lowered[15000]", data = 15000},
		},
		default = 22500,
	},


------------------------------
-- Character Reworks --
------------------------------
    Header("Character Reworks"),
------------------------------
    BinaryConfig("willow", "Willow Rework", "Lighter is infinite while Willow is holding it, she can cast explosions, Bernie is now small by default. And MUCH more!", true),
    BinaryConfig("bernie", "Willow Rework - Bernie", "Toggle if Bernie can turn into Big Bernie. Must be set on fire to transform if Enabled.", false),
    BinaryConfig("warly", "Improved Warly", "Warly gets 1.2x health and sanity from unique foods, and 1.15x hunger, similar to singleplayer. Increased food memory to 3 days.", true),


------------------------------
-- Weather --
------------------------------
    Header("Weather"),
------------------------------
    BinaryConfig("snowstorms", "Snowstorms", "Snow Overlay, Snow Piles, begone!", true),
    BinaryConfig("hayfever", "Hayfever", "I promise it was reworked to be better!", true),
    BinaryConfig("acidrain", "Acid Rain", "During later game Autumn, the Toadstool will spawn \npoisonous Mushtrees and Toadling Guards on the surface.", true),
	{
		name = "weather start date",
		label = "Start Date for New Weather.",
		hover = "Snowstorms, Hayfever, and Acid Rain.",
		options =
		{
			{description = "First Year", data = 22},
			{description = "Second Year", data = 55},
		},
		default = 22,
	},
}