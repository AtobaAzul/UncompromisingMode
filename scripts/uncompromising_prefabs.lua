local prefabs = {
	--Characters
	"winky",
	"winky_none",
	--"wixie",
	--"wathom",
	--"winslow",
	--"wickett",
	--"winky2",
	--"whoppermeal",
	--"wackytobackey",
	--"wonaldmcronald

	"deathstick",
	"uncompromising_toad",
	"mushroomsprout_overworld",
	"sporecloud_toad",
	"deerclops_ground_fx",
	"root_spike",
	"uncompromising_rat",
	"ratpoison",
	"ratpoison_debuff",
	--"ratpoisonbottle",
	"firemeteorwarning",
	"antlionwarning",
	"gasmask",
	"spiderqueencorpse",
	"lavae2",
	"mock_monsterwarningsounds",
	"mock_dragonfly",

	"moonmaw_dragonfly",
	"moonmaw_glass",
	"moonmaw_lavae",
	"glass_scales",
	"armor_glassmail",
	"armor_glassmail_shards",
	"moonmaw_trap",
	"moonmaw_glassshards",

	"lavaspit",
	--"um_sandhill",
	"snowpile",
	--"sand",
	"snowgoggles",
	"leechswarm", --buggy atm
	--"laitleech", Causes bug if not commmented out
	"shockworm",
	"zaspberry",
	"snowmong",
	"firedrop",
	"um_bearger_sinkhole",
	"minimoonspider_spike",
	"minotaur_boulder",
	"minotaur_boulder_big",
	--"monstermorsel",
	"bushcrab",
	"dreadeye",
	"creepingfear",
	"uncompromising_shadow_projectile_fx",
	"toadling",
	"iceboomerang",
	"diseasecure",
	"toadlingspawner",
	"snowball_throwable",
	"extra_monsterfoods",
	"sporepack",
	"saltpack",
	"saltpile",
	"veteranshrine",
	"rat_tail",
	"shroom_skin_fragment",
	"plaguemask",
	"trapdoor",
	"spider_trapdoor",
	"antlion_sinkhole_lava",
	"lavaeslime",
	"air_conditioner",
	"air_conditioner_smoke",
	"mothergoose",
	"mothergooseegg",
	"shadow_goo",
	"mini_dreadeye",
	"scorpion",
	"vampirebat",
	"icecreamsanityregenbuff",
	"zaspberryparfait",
	"uncompromising_foodbuffs",
	"shockfx",
	"shockstundebuff",
	"carapacecooler",
	"rnefissure",
	"honey_log",
	"pollenmites",
	"bugzapper",
	"moon_tear",
	"moon_tear_meteor",
	"rneghost",
	"chimp",
	"pollenmiteden",
	"pollenmitedenprefabspawner",
	"rice",
	--"gatorsnake",
	"riceplant",
	"acid_rain_splash",
	"walrus_camp_summer",
	"sunglasses",
	"cookiespikes",
	"skeletonmeat",
	"swilson",
	"veteranscurse",
	"healthregenbuff_vetcurse",
	"antlion_sinkhole_boat",
	"riceplantspawner",
	"critterlab_real",
	"charliephonograph",
	"stumpling",
	"shadow_teleporter",
	"shadow_teleporter_light",
	"shadowtalker",
	"shadow_crown",
	"scorpioncarapace",
	"trapdoorgrass",
	"trapdoorspawner",
	"lureplague_rat",
	"wicker_tentacle",
	"snapperturtle",
	"snapperturtlenest",
	"cursed_antler",
	"marsh_grass",
	"web_net_splat_fx",
	"web_bomb",
	--"hoodedforestturf",
	"poopregenbuff",
	"giant_tree",
	"webbedcreature",
	"widowsgrasp",
	"extracanopyspawner",
	"widowweb",
	"widowwebspawner",
	"webbedcreaturespawner",
	"hoodedwidow",
	"willowfire",
	"berniebox",
	"chomper",
	"old_shadowwaxwell",
	"snapdragon",
	"snapdragonherd",
	"snapplant",
	"giant_blueberry",
	"blueberryplant",
	"blueberryplantbuncher",
	"rambranch",
	"rambranch_horn",
	"nightmarehorn",
	"sheeplet",
	"sheepletbomb",
	"whisperpod",
	"whisperpod_normal",
	"hooded_fern",
	"uncompromising_hounds",
	"hound_lightning",
	"aphid",
	"fruitbat",
	"pitcherplant",
	"widowshead",
	"cctrinkets",
	"pinepile",
	"hooded_mushtree",
	"hooded_forest_rubble",
	"rnelevitator",
	"screecher_trinket",
	"mushdrake_red",
	"rneshadowskittish",
	"cinnamon_tree",
	"watermelon_lantern",
	"gnome_organizer",
	"fireball_throwable",
	"crabclaw",
	"ancient_trepidation",
	"ancient_trepidation_anchor",
	"klaus_amulet",
	"ancient_amulet_red",
	"buff_ancient_amulet_red",
	"amulet_health_orb",
	"nightcrawler",
	--"um_nightcrawler",
	"ancient_trepidation_arm",
	--"steel_sweater",
	"rat_whip",
	"bearger_mask",
	"rneskeleton",
	"snapdragon_fertilizer",
	"viperworm",
	"viperfruit",
	"viperjam",
	"viperprojectile",
	"bight",
	"knook",
	"roship",
	"deerclops_laser_blue",
	"gingerdeadpig_rne",
	"uncompromising_blowguns",
	"uncompromising_blowgun_ammo",
	"bearger_boulder",
	"nymph",
	"deerclops_barrier",
	"roship_projectile",
	"electric_ring",

	"cave_entrance_sunkdecid",
	"cave_exit_sunkdecid",
	"cave_entrance_ratacombs",
	"cave_exit_ratacombs",

	"um_pawn",
	"pawn_spawn",
	"pigking_pigtorch",
	"armor_dragonfly_light",
	"haul_hound",
	"mothermossling",
	"dragonfly_egg",
	"um_trap_snare",
	"um_bear_trap",
	"gore_horn_hat",
	"slobberlobber",
	"uncompromising_birds",
	"um_shambler",
	"mothergoose_tornado",
	"corncan",
	"feather_frock",
	"beargerclaw",
	"skullchest",
	"drink_with_the_living_dead",
	"hoodedturfchanger",
	"wargwarning",
	"deerclops_easyspawners",
	"armorlavae",
	"marshmist",
	"corvushat",
	"woomerang",
	"um_spider_mutators",
	--"uncompromising_alterguardianspawner",
	"driftwoodfishingrod",
	"nightlightfuel",

	"voorhams",
	"ratking",
	"ratgas",
	"ratacombs_junkpile",
	"ratacombs_junkpile_spawner",
	"ratacombslock",
	"ratacombskey",
	"ratacombslock_rock",
	"uncompromising_buffrat",
	"garbagespring",
	"uncompromising_bundles",
	"ratacombs_cleanair",
	"ratacombs_totem",
	"ratgashole",

	"rneearthquake",
	"shadowvortex",
	"nervoustick",
	"mindweaver",
	"rneshadows",
	"fuelseeker",
	"rnemushroombomb",

	"wackymask",
	"tiddlestranger_rne",
	"rne_goodiebag",

	"backupcatcoonden",
	--"moon_deerclops",
	"um_books",
	"rain_horn",
	"floral_bandage",
	"confighealbuff",
	"shockstundebuffimmunity",
	"pied_rat",
	"pied_piper_flute",

	"eyeofterror_laser",
	"eyeofterror_extras",
	"oculet",
	"oculet_pets",
	"terrarium",
	"reedbuncher",
	"itemscrapper",
	"um_areahandler",
	"specter_shipwreck",
	--"resurrectionphonograph",
	"winona_toolbox",
	"searock_arches",
	"searock_ring",
	"minotaur_organ",
	"sunkenchest_royal",
	"speaker",
	"sludge",
	"sludgestack",
	"sludge_sack",
	"boatpatch_sludge",
	"beequeen_beering",
	"cave_entrance_lush",
	"uncompromising_rocks",
	--"uncompromising_superspawner",
	"uncompromising_devcapture",
	"driftwood_waterlogged",
	"kelpstack",
	"siren_throne",

	"uncompromising_harpoon",
	"uncompromising_axepoon",
	"uncompromising_magharpoon",
	"uncompromising_fishingnet",
	"uncompromising_fishingnetvisualizer",
	"um_windturbine",
	"mastupgrade_windturbine",
	"um_beegun",

	"armor_reed_um",
	"armor_sharksuit_um",
	"rockjawleather",
	"winona_upgradekit",
	"powercell",
	"rr_powerline",
	"eyeofterror_mini_ally",
	"eyeofterror_mini_projectile_ally",

	"figgypet",
	"portableboat",
	"siren_bird_nest",
	"um_scorpionhole",
	"um_scorpionhole_organizer",
	"um_amber",
	"um_sorrel",
	"brine_balm",
	--"um_sandrock",
	"um_scorpioneggs",
	"giant_tree_birdnest",
	"uncompromising_bumpers",
	"um_copper_pipe",
	"steeringwheel_copper",
	"hermit_bundle_lures",
	"um_cannonballs",
	"um_dreamcatcher",
	"um_beeguards",
	"um_beestinger_projectile",
	"um_specter_amulet",
	"um_walls",
	"ocupus_items",
	"ums_biometable",
	"umss_general",

	"um_tornado",
	"um_whirlpool",

	"um_waterfall",
	"um_waterfall_terraformer",

	"krampus_middleman_inventory",
	"alpha_lightninggoat",

	"wathom",
	"wathom_none",

	"um_halloween_ornaments",
	"trinket_wathom1",

	"uncompromising_skins",

	"codex_mantra",

	--WIXIE RELATED PREFABS
	"charles_t_horse",
	"wixie_piano",
	"wixie_clock",
	"wixie_wardrobe",
	"slingshotammo_secondary",
	"slingshotammo_extras",
	"slingshotammo_IA",
	"slingshot_target",
	"wixie",
	"wixie_none",
	"wixiehoney_trail",
	"wixietar_trail",
	"wixie_stinkdebuff",
	"wixie_panicshield",
	"wixiecurse_debuff",
	"meatrack_hat",
	"walterbonus_buff",
	"bagofmarbles",
	"wixiebowling",
	"slingshot_gnasher",
	"slingshot_matilda",
	"shadow_wixie",
	"dried_fishmeats",
	"bigwoby_debuff",
	"woby_target",
	"wixie_stinkcloud",
	"wixiegun",
	
	"winona_structure_item",
	"boiling_water",
	"crabking_geyser_single",
	"staff_starfall",
	"staff_moonfall",
	"armor_crab",
	"hat_crab",
	"trident_ground_fx",
	"moon_beacon",
	"goat_lightning",

	"mara_boss1",
	"mara_boss1_bullets",
	"um_sacred_chest",
	"smog",
    
	-- Pyre Nettle stuff
	"um_pyre_nettles",
	"um_smolder_spore",
	"umdebuff_pyre_toxin",
	"um_armor_pyre_nettles",
	"um_blowdart_pyre",
	
	-- Mutation Extrapolation
	"umdebuff_moonburn",
	"um_pathfinderpulse",
	
	"um_preparedfoods",
	"um_foliage",
	"lifeinjector_redcap_buff",

    "dl_prefabs",
    "dl_biometable",

    "sea_shadow",
    "kaleidoscope"
}

if TUNING.DSTU ~= nil and TUNING.DSTU.WIXIE ~= nil and TUNING.DSTU.WIXIE then
	table.insert(prefabs, "placeholder_recipe_item")
end

return prefabs