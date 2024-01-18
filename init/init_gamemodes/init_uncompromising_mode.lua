local require = GLOBAL.require

--	[ 	Import Prefabs, Assets, Widgets and Util	]	--
modimport("init/init_util")
modimport("init/init_assets")
modimport("init/init_widgets")
modimport("init/minimap_icons")

--  [   Import customized shard RPC module ]    --


--  [   Mock Dragonfly Spit Bait ]    --
modimport("init/init_weather/init_dragonfly_bait")

--  [  	Over Eating Nerf	     ]    --
--modimport("init/init_food/init_stuffed")
--Currently shelved due to hunger upvalue return error

--	[ 	Import Names and Descriptions	]	--
modimport("init/init_names")
modimport("init/init_bonusdescriptors")
modimport("init/init_descriptions/generic")
modimport("init/init_descriptions/willow")
modimport("init/init_descriptions/wolfgang")
modimport("init/init_descriptions/wendy")
modimport("init/init_descriptions/wx78")
modimport("init/init_descriptions/wickerbottom")
modimport("init/init_descriptions/woodie")
modimport("init/init_descriptions/wes")
modimport("init/init_descriptions/waxwell")
modimport("init/init_descriptions/wathgrithr")
modimport("init/init_descriptions/webber")
modimport("init/init_descriptions/winona")
modimport("init/init_descriptions/wortox")
modimport("init/init_descriptions/wormwood")
modimport("init/init_descriptions/warly")
modimport("init/init_descriptions/wurt")
modimport("init/init_descriptions/walter")
modimport("init/init_descriptions/wanda")
modimport("init/init_descriptions/winky")
modimport("init/init_descriptions/wathom")

--	[ 		Number Tuning and PostInits		]	--

modimport("init/init_tuning")
modimport("init/init_postinit")
modimport("init/init_strings")
modimport("init/init_tooltips")
modimport("init/init_actions")
modimport("init/init_containers")
modimport("init/init_batterypower")
modimport("init/init_sweaterpower")
modimport("init/init_rpctrackers")
modimport("init/init_creatures/init_ediblebugs")
modimport("init/init_creatures/init_bear_trap_immune")
modimport("init/init_generatorcharging")
--	[ 	Console Commands for tests !	]	--

require("uncompromisingcommands")
modimport("scripts/uncompromisingcommands_autocomplete")

--	[ 				Gamemodes			]	--

local GAMEMODE_UNCOMPROMISING = 0;
local GAMEMODE_CUSTOM_SETTINGS = 2;

--if GLOBAL.GetGameModeProperty("hardcore") then
--modimport("init/init_gamemodes/init_hardcore") --TODO: Fix hardcore game mode. For now, it is a mod config below.
--end

--	[ 				Features			]	--



--if GetModConfigData("harder_monsters") then
modimport("init/init_creatures/init_treebuffs")
modimport("init/init_creatures/init_harder_monsters")
--end

if GetModConfigData("horriblefood") then
	modimport("init/init_horriblefood")
end

modimport("init/init_food/init_food_changes")
modimport("init/init_food/init_bird_changes")
modimport("init/init_food/init_rare_foods")
modimport("init/init_vetcurse")
modimport("init/init_bosshealth")

--if  GetModConfigData("harder_recipes") then <-- This isn't even a config change, yet.
modimport("init/init_recipes")
modimport("init/init_food/init_crockpot")
modimport("init/init_food/monsterfoods")
--end

if GetModConfigData("rat_raids") then
	modimport("init/init_ratraid")
	modimport("init/init_noratcheck")
end

modimport("init/init_creatures/init_knockback")

if GetModConfigData("harder_shadows") then
	modimport("init/init_creatures/init_harder_shadows")
	modimport("postinit/prefabs/shadowcreature")
	modimport("postinit/stategraphs/SGshadowcreature")
end

--if  GetModConfigData("harder_weather") then <-- This isn't even a config change, yet.
--modimport("init/init_weather/init_acidmushroom_networking")
--modimport("init/init_weather/init_acid_rain_effects")
--modimport("init/init_weather/init_acid_rain_disease")
modimport("init/init_weather/init_harder_weather")
--modimport("init/init_weather/init_snowstorm")
modimport("init/init_weather/init_snowstorm_structures")
if GetModConfigData("smog") then
	modimport("init/init_weather/init_smog")
end
--end

if GetModConfigData("acidrain") then
	--modimport("init/init_uncompromisingshardrpc")
	modimport("init/init_weather/init_acidmushroom_networking")
	modimport("postinit/prefabs/toadstool_cap")
end

if GetModConfigData("snowstorms") then
	modimport("init/init_weather/init_snowstorm")
end

if GetModConfigData("hayfever_disable") then
	modimport("init/init_weather/init_hayfever")
	modimport("init/init_creatures/init_sneeze_hitters")
end

modimport("init/init_durability")

if GetModConfigData("willow") then
	modimport("init/init_character_changes/willow")
end

modimport("init/init_character_changes/willow_bernie")

--[[if GetModConfigData("gamemode") == GAMEMODE_UNCOMPROMISING and GetModConfigData("waxwell") or
	(GetModConfigData("gamemode") == GAMEMODE_CUSTOM_SETTINGS and GetModConfigData("waxwell")) then
		modimport("init/init_character_changes/waxwell")
	end]]

--if GetModConfigData("warly") then
	--modimport("init/init_character_changes/warly")
--end

--if GetModConfigData("wolfgang") then
--modimport("init/init_character_changes/wolfgang")
modimport("init/init_character_changes/wolfgang2")
modimport("init/init_character_changes/wormwood")
--end

if GetModConfigData("lifeamulet") then
	modimport("init/init_lifeamulet")
end

--if GetModConfigData("caved") == false and GetModConfigData("acidrain") then
	--modimport("init/init_weather/init_overworld_toadstool")
--end

if GetModConfigData("foodregen") then
	modimport("init/init_food/init_foodregen")
end

--TODO: Add settings for each individual character after we add many changes
--if GetModConfigData("character_changes") then <-- This isn't even a config option.
modimport("init/init_character_changes/generic")
modimport("init/init_character_changes/wendy")
modimport("init/init_character_changes/wx78")
modimport("init/init_character_changes/wickerbottom")
modimport("init/init_character_changes/woodie")
modimport("init/init_character_changes/wes")
modimport("init/init_character_changes/wathgrithr")
modimport("init/init_character_changes/webber")
modimport("init/init_character_changes/winona")
modimport("init/init_character_changes/wanda")

if GetModConfigData("wortox") then
	modimport("init/init_character_changes/wortox")
end	

modimport("init/init_character_changes/warly")

if GetModConfigData("waxwell") then
	modimport("init/init_character_changes/waxwell")
end

if GetModConfigData("hardcore") then
	modimport("init/init_gamemodes/init_hardcore")
end

modimport("init/init_loadingtips")
