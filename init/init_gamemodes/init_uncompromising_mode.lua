local require = GLOBAL.require

--	[ 	Import Prefabs, Assets, Widgets	]	--
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
	
--	[ 		Number Tuning and PostInits		]	--

	modimport("init/init_tuning")
	modimport("init/init_postinit")
	modimport("init/init_strings")
	modimport("init/init_actions")
	modimport("init/init_containers")
	modimport("init/init_batterypower")
	modimport("init/init_sweaterpower")
	modimport("init/init_rpctrackers")
	modimport("init/init_creatures/init_ediblebugs")
	modimport("init/init_creatures/init_bear_trap_immune")
	
--	[ 	Console Commands for tests !	]	--
	
	require("uncompromisingcommands")
	
--	[ 				Gamemodes			]	--
	
	local GAMEMODE_UNCOMPROMISING = 0;
	local GAMEMODE_CUSTOM_SETTINGS = 2;

	--if GLOBAL.GetGameModeProperty("hardcore") then
		--modimport("init/init_gamemodes/init_hardcore") --TODO: Fix hardcore game mode. For now, it is a mod config below.
	--end
	
--	[ 				Features			]	--
	


	--if GetModConfigData("harder_monsters") == true then
		modimport("init/init_creatures/init_treebuffs")
		modimport("init/init_creatures/init_harder_monsters")
	--end


	modimport("init/init_food/init_food_changes")
	modimport("init/init_food/init_bird_changes")
	modimport("init/init_food/init_rare_foods")
	modimport("init/init_food/init_disableregrowth")


	--if  GetModConfigData("harder_recipes") == true then <-- This isn't even a config change, yet.
		modimport("init/init_recipes")
		modimport("init/init_food/init_crockpot")
		modimport("init/init_food/monsterfoods")
	--end

	if GetModConfigData("rat_raids") == true then
		modimport("init/init_ratraid")
	end

	modimport("init/init_creatures/init_knockback")

	if GetModConfigData("harder_shadows") == true then
		modimport("init/init_creatures/init_harder_shadows")
		--modimport("init/init_creatures/init_shadowspawner")
		modimport("postinit/prefabs/shadowcreature")
		modimport("postinit/stategraphs/SGshadowcreature")
	end

	--if  GetModConfigData("harder_weather") == true then <-- This isn't even a config change, yet.
		--modimport("init/init_weather/init_acidmushroom_networking")
		modimport("init/init_weather/init_acid_rain_effects")
		modimport("init/init_weather/init_acid_rain_disease")
		modimport("init/init_weather/init_harder_weather")
		--modimport("init/init_weather/init_snowstorm")
		--modimport("init/init_weather/init_snowstorm_structures")
	--end
	
	if GetModConfigData("acidrain") == true then
		--modimport("init/init_uncompromisingshardrpc")
		modimport("init/init_weather/init_acidmushroom_networking")
		modimport("postinit/prefabs/toadstool_cap")
	end
	
	if GetModConfigData("snowstorms") == true then
		modimport("init/init_weather/init_snowstorm")
	end
	
	if GetModConfigData("hayfever") == true then
		modimport("init/init_weather/init_hayfever")
		modimport("init/init_creatures/init_sneeze_hitters")
	end
	
	modimport("init/init_durability")
	
	if GetModConfigData("willow") == true then
		modimport("init/init_character_changes/willow")
	end
	
	if  GetModConfigData("bernie") == false then
		modimport("init/init_character_changes/willow_bernie")
	end
	
	--[[if GetModConfigData("gamemode") == GAMEMODE_UNCOMPROMISING and GetModConfigData("waxwell") == true or
	(GetModConfigData("gamemode") == GAMEMODE_CUSTOM_SETTINGS and GetModConfigData("waxwell") == true) then
		modimport("init/init_character_changes/waxwell")
	end]]
	
	if GetModConfigData("warly") == true  then
		modimport("init/init_character_changes/warly")
	end
	
	if GetModConfigData("wolfgang") == true then
		--modimport("init/init_character_changes/wolfgang")
	end
	
	if GetModConfigData("lifeamulet") == true then
		modimport("init/init_lifeamulet")
	end
	
	if GetModConfigData("caved") == false and GetModConfigData("acidrain") == true then
		modimport("init/init_weather/init_overworld_toadstool")
	end
	
	if  GetModConfigData("crabking_claws") == true then
		modimport("postinit/prefabs/crabking_claw")
	end
	
	if GetModConfigData("foodregen") == true  then
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
		
	if GetModConfigData("wortox") == true then
		modimport("init/init_character_changes/wortox")
	end
	
		modimport("init/init_character_changes/wormwood")
		modimport("init/init_character_changes/waxwell")
	--end

	if GetModConfigData("hardcore") then
		modimport("init/init_gamemodes/init_hardcore")
	end

