RemapSoundEvent("dontstarve/characters/winky/death_voice", "winky/characters/winky/death_voice")
RemapSoundEvent("dontstarve/characters/winky/hurt", "winky/characters/winky/hurt")
RemapSoundEvent("dontstarve/characters/winky/talk_LP", "winky/characters/winky/talk_LP")
RemapSoundEvent("dontstarve/characters/winky/ghost_LP", "winky/characters/winky/ghost_LP")
RemapSoundEvent("dontstarve/characters/winky/nightmare_LP", "winky/characters/winky/nightmare_LP")
RemapSoundEvent("dontstarve/characters/winky/yawn", "winky/characters/winky/yawn")
RemapSoundEvent("dontstarve/characters/winky/emote", "winky/characters/winky/emote")
RemapSoundEvent("dontstarve/characters/winky/pose", "winky/characters/winky/pose")
RemapSoundEvent("dontstarve/characters/winky/yawn", "winky/characters/winky/yawn")
RemapSoundEvent("dontstarve/characters/winky/eye_rub_vo", "winky/characters/winky/eye_rub_vo")
RemapSoundEvent("dontstarve/characters/winky/carol", "winky/characters/winky/carol")
RemapSoundEvent("dontstarve/characters/winky/sinking", "winky/characters/winky/sinking")

--Items
--Registering all item atlas so we don't have to keep doing it on each craft/prefab.
--PLEASE keep atlas names and image names the same so we can continue to do this like this.
local inventoryitems =
{
	"air_conditioner",
	"ancient_amulet_red",
	"aphid",
	"armor_glassmail",
	"beargerclaw",
	"beefalowings",
	"berniebox",
	"blowgunammo_electric",
	"blowgunammo_fire",
	"blowgunammo_sleep",
	"blowgunammo_tooth",
	"blue_mushed_room",
	"blueberrypancakes",
	"bluegem_cracked",
	"book_rain_um",
	"bugzapper",
	"californiaking",
	"cctrinket_don",
	"cctrinket_freddo",
	"cctrinket_jazzy",
	"codex_mantra",
	"chester_eyebone_closed_lazy",
	"chester_eyebone_lazy",
	"cookedmonstersmallmeat",
	"corncan",
	"corvushat",
	"crabclaw",
	"critterlab_real",
	"cursed_antler",
	"dart_red",
	"devilsfruitcake",
	"diseasebomb",
	"diseasecurebomb",
	"dormant_rain_horn",
	"driftwoodfishingrod",
	"feather_frock",
	"floral_bandage",
	"gasmask",
	"giant_blueberry",
	"glass_scales",
	"gore_horn_hat",
	"grassgekko",
	"green_mushed_room",
	"green_vomit",
	"greenfoliage",
	"greengem_cracked",
	"greensteamedhams",
	"hardshelltacos",
	"hat_bagmask",
	"hat_blackcatmask",
	"hat_clownmask",
	"hat_devilmask",
	"hat_fiendmask",
	"hat_ghostmask",
	"hat_globmask",
	"hat_hockeymask",
	"hat_joyousmask",
	"hat_mandrakemask",
	"hat_mermmask",
	"hat_oozemask",
	"hat_opossummask",
	"hat_orangecatmask",
	"hat_phantommask",
	"hat_pigmask",
	"hat_pumpgoremask",
	"hat_ratmask",
	"hat_redskullmask",
	"hat_spectremask",
	"hat_technomask",
	"hat_wathommask",
	"hat_whitecatmask",
	"honey_log",
	"iceboomerang",
	"klaus_amulet",
	"liceloaf",
	"monstersmallmeat",
	"monstersmallmeat_dried",
	"moon_tear",
	"moonglass_geode",
	"mutator_trapdoor",
	"nervoustick_1",
	"nervoustick_2",
	"nervoustick_3",
	"nervoustick_4",
	"nervoustick_5",
	"nervoustick_6",
	"nervoustick_7",
	"nervoustick_8",
	"oculet",
	"opalpreciousgem_cracked",
	"orange_vomit",
	"orangegem_cracked",
	"pale_vomit",
	"pied_piper_flute",
	"pink_vomit",
	"plaguemask",
	"purple_vomit",
	"purplegem_cracked",
	"purplesteamedhams",
	"rain_horn",
	"rat_fur",
	"rat_tail",
	"rat_whip",
	"ratpoisonbottle",
	"red_mushed_room",
	"red_vomit",
	"redgem_cracked",
	"rice",
	"rice_cooked",
	"rne_goodiebag",
	"saltpack",
	--"sand",
	"scorpioncarapace",
	"scorpioncarapacecooked",
	"screecher_trinket",
	"seafoodpaella",
	"shadow_crown",
	"shroom_skin_fragment",
	"simpsalad",
	"skeletonmeat",
	"skullchest_child",
	"skullflask",
	"skullflask_empty",
	"slobberlobber",
	"snapplant",
	"snotroast",
	"snowball_throwable",
	"snowcone",
	"snowgoggles",
	"spider_trapdoor",
	"sporepack",
	"stanton_shadow_tonic",
	"stanton_shadow_tonic_fancy",
	"steamedhams",
	"stuffed_peeper_poppers",
	"sunglasses",
	"theatercorn",
	"turf_ancienthoodedturf",
	"turf_hoodedmoss",
	"um_bear_trap_equippable",
	"um_bear_trap_equippable_gold",
	"um_bear_trap_equippable_tooth",
	"um_deviled_eggs",
	"um_magnerang",
	"um_monsteregg",
	"um_monsteregg_cooked",
	"uncompromising_blowgun",
	"uncompromising_fishingnet",
	"uncompromising_harpoon",
	"viperfruit",
	"viperjam",
	"watermelon_lantern",
	"whisperpod",
	"widowsgrasp",
	"widowshead",
	"woodpecker",
	"yellow_vomit",
	"yellowgem_cracked",
	"zaspberry",
	"zaspberryparfait",

	"um_beegun",
	"um_beegun_cherry",
	"bulletbee",
	"cherrybulletbee",
	"sludge",
	"sludge_cork",
	"sludge_sack",
	"cannonball_sludge_item",
	"boatpatch_sludge",
	"uncompromising_harpoon_heavy",
	"rockjawleather",
	"armor_sharksuit_um",
	"boat_bumper_sludge_kit",
	"armor_reed_um",
	"boat_bumper_copper_kit",
	"um_copper_pipe",
	"powercell",
	"winona_toolbox",
	"winona_upgradekit_electrical",
	"portableboat_item",
	"critter_figgy_builder",
	"ocupus_tentacle",
	"ocupus_tentacle_eye",
	"ocupus_tentacle_cooked",
	"ocupus_beak",
	"um_brineishmoss",
	"brine_balm",
	"sludge_oil",
	"mastupgrade_windturbine_item",
	"charles_t_horse",
	"the_real_charles_t_horse",
	"um_ornament_opossum",
	"um_ornament_rat",
	"trinket_wathom1",
	"wooden_queen_piece",
	"wixie_piano_card",
	
	--Magma Caves icons
	"um_smolder_spore",
	"um_armor_pyre_nettles",
	"um_blowdart_pyre",
	
	-- Mutation Extrapolation
	"um_staff_meteor",

	--Wixie related inventory icons

	"slingshot_gnasher",
	"slingshot_matilda",
	"slingshotammo_firecrackers",
	"slingshotammo_honey",
	"slingshotammo_rubber",
	"slingshotammo_tremor",
	"slingshotammo_moonrock",
	"slingshotammo_moonglass",
	"slingshotammo_salt",
	"slingshotammo_limestone",
	"slingshotammo_tar",
	"slingshotammo_obsidian",
	"slingshotammo_goop",
	"slingshotammo_slime",
	"slingshotammo_lazy",
	"slingshotammo_shadow",
	"bagofmarbles",

	"placeholder_ingredient_ia",
	"placeholder_ingredient_ia_um",

	--Walters jerky hats
	"meatrack_hat",
	"meatrack_hat_batnose",
	"meatrack_hat_batwing",
	"meatrack_hat_drumstick",
	"meatrack_hat_eel",
	"meatrack_hat_fish",
	"meatrack_hat_fishmeat",
	"meatrack_hat_fishmeat_small",
	"meatrack_hat_froglegs",
	"meatrack_hat_humanmeat",
	"meatrack_hat_kelp",
	"meatrack_hat_meat",
	"meatrack_hat_monstermeat",
	"meatrack_hat_monstersmallmeat",
	"meatrack_hat_default",
	"meatrack_hat_plantmeat",
	"meatrack_hat_smallmeat",

	--ia (and possibly hamlet) related wixie icons
	"meatrack_hat_solofish_dead",
	"meatrack_hat_swordfish_dead",
	"meatrack_hat_jellyfish_dead",
	"meatrack_hat_rainbowjellyfish_dead",
	"meatrack_hat_fish_tropical",
	"meatrack_hat_seaweed",
	"meatrack_hat_venus_stalk",
	"meatrack_hat_froglegs_poison",

	--skins
	"ms_ancient_amulet_red_demoneye",
	"ms_hat_plaguemask_formal",
	"ms_plaguemask_formal", --dunno??
	"ms_feather_frock_fancy",
	"ms_twisted_antler",

	--winona stuff
	"winona_battery_low_item",
	"winona_battery_high_item",
	"winona_spotlight_item",
	"winona_catapult_item",

	--crab king items
	"hat_crab",
	"staff_starfall",
}

for k, v in ipairs(inventoryitems) do
	RegisterInventoryItemAtlas(GLOBAL.resolvefilepath("images/inventoryimages/" .. v .. ".xml"), v .. ".tex")
end

Assets = {
	--crafting menu avatars
	Asset("IMAGE", "images/crafting_menu_avatars/avatar_wixie.tex"),
	Asset("ATLAS", "images/crafting_menu_avatars/avatar_wixie.xml"),
	Asset("IMAGE", "images/crafting_menu_avatars/avatar_winky.tex"),
	Asset("ATLAS", "images/crafting_menu_avatars/avatar_winky.xml"),
	Asset("IMAGE", "images/crafting_menu_avatars/avatar_wathom.tex"),
	Asset("ATLAS", "images/crafting_menu_avatars/avatar_wathom.xml"),

	----TURF
	Asset("IMAGE", "levels/textures/noise_hoodedmoss.tex"),
	Asset("IMAGE", "levels/textures/mini_noise_jungle.tex"),
	Asset("IMAGE", "levels/tiles/jungle.tex"),
	Asset("FILE", "levels/tiles/jungle.xml"),
	Asset("ANIM", "anim/hfturf.zip"),
	Asset("ANIM", "anim/swturf.zip"),
	----ASSET("ATLAS_BUILD", "images/inventoryimages/turf_jungle.xml"),
	--Asset("ATLAS", "images/inventoryimages/turf_jungle.xml"),
	--Asset("IMAGE", "images/inventoryimages/turf_jungle.tex"),
	----Turf



	--WINKY!!!

	Asset("IMAGE", "images/saveslot_portraits/winky.tex"),
	Asset("ATLAS", "images/saveslot_portraits/winky.xml"),

	Asset("IMAGE", "images/selectscreen_portraits/winky.tex"),
	Asset("ATLAS", "images/selectscreen_portraits/winky.xml"),
	Asset("IMAGE", "images/selectscreen_portraits/winky_silho.tex"),
	Asset("ATLAS", "images/selectscreen_portraits/winky_silho.xml"),

	Asset("IMAGE", "bigportraits/winky.tex"),
	Asset("ATLAS", "bigportraits/winky.xml"),
	Asset("IMAGE", "bigportraits/winky_none.tex"),
	Asset("ATLAS", "bigportraits/winky_none.xml"),

	Asset("IMAGE", "images/map_icons/winky.tex"),
	Asset("ATLAS", "images/map_icons/winky.xml"),

	Asset("IMAGE", "images/avatars/avatar_winky.tex"),
	Asset("ATLAS", "images/avatars/avatar_winky.xml"),

	Asset("IMAGE", "images/avatars/avatar_ghost_winky.tex"),
	Asset("ATLAS", "images/avatars/avatar_ghost_winky.xml"),

	Asset("IMAGE", "images/avatars/self_inspect_winky.tex"),
	Asset("ATLAS", "images/avatars/self_inspect_winky.xml"),

	Asset("IMAGE", "images/names_gold_winky.tex"),
	Asset("ATLAS", "images/names_gold_winky.xml"),

	Asset("IMAGE", "images/names_winky.tex"),
	Asset("ATLAS", "images/names_winky.xml"),

	Asset("SOUNDPACKAGE", "sound/winky.fev"),
	Asset("SOUND", "sound/winky.fsb"),



	-- WATHOM!!!
	Asset("ANIM", "anim/vvathom_run.zip"),
	Asset("ANIM", "anim/ampbadge.zip"),

	Asset("IMAGE", "images/saveslot_portraits/wathom.tex"),
	Asset("ATLAS", "images/saveslot_portraits/wathom.xml"),

	Asset("IMAGE", "images/selectscreen_portraits/wathom.tex"),
	Asset("ATLAS", "images/selectscreen_portraits/wathom.xml"),
	Asset("IMAGE", "images/selectscreen_portraits/wathom_silho.tex"),
	Asset("ATLAS", "images/selectscreen_portraits/wathom_silho.xml"),

	Asset("IMAGE", "bigportraits/wathom.tex"),
	Asset("ATLAS", "bigportraits/wathom.xml"),
	Asset("IMAGE", "bigportraits/wathom_none.tex"),
	Asset("ATLAS", "bigportraits/wathom_none.xml"),

	Asset("IMAGE", "images/map_icons/wathom.tex"),
	Asset("ATLAS", "images/map_icons/wathom.xml"),

	Asset("IMAGE", "images/avatars/avatar_wathom.tex"),
	Asset("ATLAS", "images/avatars/avatar_wathom.xml"),

	Asset("IMAGE", "images/avatars/avatar_ghost_wathom.tex"),
	Asset("ATLAS", "images/avatars/avatar_ghost_wathom.xml"),

	Asset("IMAGE", "images/avatars/self_inspect_wathom.tex"),
	Asset("ATLAS", "images/avatars/self_inspect_wathom.xml"),

	Asset("IMAGE", "images/names_wathom.tex"),
	Asset("ATLAS", "images/names_wathom.xml"),

	Asset("IMAGE", "images/names_gold_wathom.tex"),
	Asset("ATLAS", "images/names_gold_wathom.xml"),

	Asset("ANIM", "anim/wathom_triumphant.zip"),
	Asset("ANIM", "anim/wathom_shadow_triumphant.zip"),

	Asset("IMAGE", "bigportraits/wathom_triumphant.tex"),
	Asset("ATLAS", "bigportraits/wathom_triumphant.xml"),

	-- ITS WIXIE!!! (Also walter...)

	Asset("ANIM", "anim/wixie.zip"),
	Asset("ANIM", "anim/ghost_wixie_build.zip"),
	Asset("ANIM", "anim/wixie_idle.zip"),

	Asset("ANIM", "anim/wixie_shadowclone.zip"),

	Asset("ANIM", "anim/wixieammo.zip"),
	Asset("ANIM", "anim/wixieammo_IA.zip"),
	Asset("ANIM", "anim/shadowvortex.zip"),
	Asset("ANIM", "anim/goldshattered.zip"),
	Asset("ANIM", "anim/curse_muncher.zip"),
	Asset("ANIM", "anim/bowlingping.zip"),
	Asset("ANIM", "anim/walterwhistle.zip"),
	Asset("ANIM", "anim/walter_heal_fx.zip"),
	Asset("ANIM", "anim/marblebag.zip"),
	Asset("ANIM", "anim/swap_marblebag.zip"),
	Asset("ANIM", "anim/baggedmarbles.zip"),

	Asset("ANIM", "anim/swap_wixiegun.zip"),

	Asset("ANIM", "anim/wixie_slimeball.zip"),

	Asset("ANIM", "anim/slingshot_matilda.zip"),
	Asset("ANIM", "anim/swap_slingshot_matilda.zip"),
	Asset("ANIM", "anim/slingshot_gnasher.zip"),
	Asset("ANIM", "anim/swap_slingshot_gnasher.zip"),

	Asset("ANIM", "anim/fishmeats.zip"),
	Asset("ANIM", "anim/driedfishmeat.zip"),

	Asset("ANIM", "anim/meatrack_hat_swap.zip"),
	Asset("ANIM", "anim/meatrack_hat_swap_batnose.zip"),
	Asset("ANIM", "anim/meatrack_hat_swap_batwing.zip"),
	Asset("ANIM", "anim/meatrack_hat_swap_default.zip"),
	Asset("ANIM", "anim/meatrack_hat_swap_drumstick.zip"),
	Asset("ANIM", "anim/meatrack_hat_swap_eel.zip"),
	Asset("ANIM", "anim/meatrack_hat_swap_fish.zip"),
	Asset("ANIM", "anim/meatrack_hat_swap_fishmeat.zip"),
	Asset("ANIM", "anim/meatrack_hat_swap_fishmeat_small.zip"),
	Asset("ANIM", "anim/meatrack_hat_swap_froglegs.zip"),
	Asset("ANIM", "anim/meatrack_hat_swap_humanmeat.zip"),
	Asset("ANIM", "anim/meatrack_hat_swap_kelp.zip"),
	Asset("ANIM", "anim/meatrack_hat_swap_meat.zip"),
	Asset("ANIM", "anim/meatrack_hat_swap_monstermeat.zip"),
	Asset("ANIM", "anim/meatrack_hat_swap_plantmeat.zip"),
	Asset("ANIM", "anim/meatrack_hat_swap_smallmeat.zip"),

	--Uncompromising Mode
	Asset("ANIM", "anim/meatrack_hat_swap_monstersmallmeat.zip"),

	--Shipwrecked and Hamlet Jerky Hats

	Asset("ANIM", "anim/meatrack_hat_swap_solofish_dead.zip"),
	Asset("ANIM", "anim/meatrack_hat_swap_swordfish_dead.zip"),
	Asset("ANIM", "anim/meatrack_hat_swap_jellyfish_dead.zip"),
	Asset("ANIM", "anim/meatrack_hat_swap_rainbowjellyfish_dead.zip"),
	Asset("ANIM", "anim/meatrack_hat_swap_fish_tropical.zip"),
	Asset("ANIM", "anim/meatrack_hat_swap_seaweed.zip"),
	Asset("ANIM", "anim/meatrack_hat_swap_venus_stalk.zip"),
	Asset("ANIM", "anim/meatrack_hat_swap_froglegs_poison.zip"),

	Asset("ANIM", "anim/status_meter_woby_small.zip"),
	Asset("ANIM", "anim/woby_big_command.zip"),
	Asset("ANIM", "anim/woby_does_a_flip.zip"),

	Asset("IMAGE", "images/inventoryimages/slingshotammo_firecrackers.tex"),
	Asset("ATLAS", "images/inventoryimages/slingshotammo_firecrackers.xml"),
	Asset("IMAGE", "images/inventoryimages/slingshotammo_honey.tex"),
	Asset("ATLAS", "images/inventoryimages/slingshotammo_honey.xml"),
	Asset("IMAGE", "images/inventoryimages/slingshotammo_rubber.tex"),
	Asset("ATLAS", "images/inventoryimages/slingshotammo_rubber.xml"),
	Asset("IMAGE", "images/inventoryimages/slingshotammo_tremor.tex"),
	Asset("ATLAS", "images/inventoryimages/slingshotammo_tremor.xml"),
	Asset("IMAGE", "images/inventoryimages/slingshotammo_moonrock.tex"),
	Asset("ATLAS", "images/inventoryimages/slingshotammo_moonrock.xml"),
	Asset("IMAGE", "images/inventoryimages/slingshotammo_moonglass.tex"),
	Asset("ATLAS", "images/inventoryimages/slingshotammo_moonglass.xml"),
	Asset("IMAGE", "images/inventoryimages/slingshotammo_salt.tex"),
	Asset("ATLAS", "images/inventoryimages/slingshotammo_salt.xml"),
	Asset("IMAGE", "images/inventoryimages/slingshotammo_limestone.tex"),
	Asset("ATLAS", "images/inventoryimages/slingshotammo_limestone.xml"),
	Asset("IMAGE", "images/inventoryimages/slingshotammo_tar.tex"),
	Asset("ATLAS", "images/inventoryimages/slingshotammo_tar.xml"),
	Asset("IMAGE", "images/inventoryimages/slingshotammo_obsidian.tex"),
	Asset("ATLAS", "images/inventoryimages/slingshotammo_obsidian.xml"),
	Asset("IMAGE", "images/inventoryimages/slingshotammo_goop.tex"),
	Asset("ATLAS", "images/inventoryimages/slingshotammo_goop.xml"),
	Asset("IMAGE", "images/inventoryimages/slingshotammo_slime.tex"),
	Asset("ATLAS", "images/inventoryimages/slingshotammo_slime.xml"),
	Asset("IMAGE", "images/inventoryimages/slingshotammo_lazy.tex"),
	Asset("ATLAS", "images/inventoryimages/slingshotammo_lazy.xml"),
	Asset("IMAGE", "images/inventoryimages/slingshotammo_shadow.tex"),
	Asset("ATLAS", "images/inventoryimages/slingshotammo_shadow.xml"),
	Asset("IMAGE", "images/inventoryimages/placeholder_ingredient_ia.tex"),
	Asset("ATLAS", "images/inventoryimages/placeholder_ingredient_ia.xml"),
	Asset("IMAGE", "images/inventoryimages/placeholder_ingredient_ia_um.tex"),
	Asset("ATLAS", "images/inventoryimages/placeholder_ingredient_ia_um.xml"),
	Asset("IMAGE", "images/inventoryimages/meatrack_hat.tex"),
	Asset("ATLAS", "images/inventoryimages/meatrack_hat.xml"),
	Asset("IMAGE", "images/inventoryimages/meatrack_hat_batnose.tex"),
	Asset("ATLAS", "images/inventoryimages/meatrack_hat_batnose.xml"),
	Asset("IMAGE", "images/inventoryimages/meatrack_hat_batwing.tex"),
	Asset("ATLAS", "images/inventoryimages/meatrack_hat_batwing.xml"),
	Asset("IMAGE", "images/inventoryimages/meatrack_hat_default.tex"),
	Asset("ATLAS", "images/inventoryimages/meatrack_hat_default.xml"),
	Asset("IMAGE", "images/inventoryimages/meatrack_hat_drumstick.tex"),
	Asset("ATLAS", "images/inventoryimages/meatrack_hat_drumstick.xml"),
	Asset("IMAGE", "images/inventoryimages/meatrack_hat_eel.tex"),
	Asset("ATLAS", "images/inventoryimages/meatrack_hat_eel.xml"),
	Asset("IMAGE", "images/inventoryimages/meatrack_hat_fish.tex"),
	Asset("ATLAS", "images/inventoryimages/meatrack_hat_fish.xml"),
	Asset("IMAGE", "images/inventoryimages/meatrack_hat_fishmeat.tex"),
	Asset("ATLAS", "images/inventoryimages/meatrack_hat_fishmeat.xml"),
	Asset("IMAGE", "images/inventoryimages/meatrack_hat_fishmeat_small.tex"),
	Asset("ATLAS", "images/inventoryimages/meatrack_hat_fishmeat_small.xml"),
	Asset("IMAGE", "images/inventoryimages/meatrack_hat_froglegs.tex"),
	Asset("ATLAS", "images/inventoryimages/meatrack_hat_froglegs.xml"),
	Asset("IMAGE", "images/inventoryimages/meatrack_hat_humanmeat.tex"),
	Asset("ATLAS", "images/inventoryimages/meatrack_hat_humanmeat.xml"),
	Asset("IMAGE", "images/inventoryimages/meatrack_hat_kelp.tex"),
	Asset("ATLAS", "images/inventoryimages/meatrack_hat_kelp.xml"),
	Asset("IMAGE", "images/inventoryimages/meatrack_hat_meat.tex"),
	Asset("ATLAS", "images/inventoryimages/meatrack_hat_meat.xml"),
	Asset("IMAGE", "images/inventoryimages/meatrack_hat_monstermeat.tex"),
	Asset("ATLAS", "images/inventoryimages/meatrack_hat_monstermeat.xml"),
	Asset("IMAGE", "images/inventoryimages/meatrack_hat_plantmeat.tex"),
	Asset("ATLAS", "images/inventoryimages/meatrack_hat_plantmeat.xml"),
	Asset("IMAGE", "images/inventoryimages/meatrack_hat_smallmeat.tex"),
	Asset("ATLAS", "images/inventoryimages/meatrack_hat_smallmeat.xml"),

	--Uncompromising Mode Jerky Hats
	Asset("IMAGE", "images/inventoryimages/meatrack_hat_monstersmallmeat.tex"),
	Asset("ATLAS", "images/inventoryimages/meatrack_hat_monstersmallmeat.xml"),

	--Shipwrecked and Hamlet Jerky Hats
	Asset("IMAGE", "images/inventoryimages/meatrack_hat_solofish_dead.tex"),
	Asset("ATLAS", "images/inventoryimages/meatrack_hat_solofish_dead.xml"),
	Asset("IMAGE", "images/inventoryimages/meatrack_hat_swordfish_dead.tex"),
	Asset("ATLAS", "images/inventoryimages/meatrack_hat_swordfish_dead.xml"),
	Asset("IMAGE", "images/inventoryimages/meatrack_hat_jellyfish_dead.tex"),
	Asset("ATLAS", "images/inventoryimages/meatrack_hat_jellyfish_dead.xml"),
	Asset("IMAGE", "images/inventoryimages/meatrack_hat_rainbowjellyfish_dead.tex"),
	Asset("ATLAS", "images/inventoryimages/meatrack_hat_rainbowjellyfish_dead.xml"),
	Asset("IMAGE", "images/inventoryimages/meatrack_hat_fish_tropical.tex"),
	Asset("ATLAS", "images/inventoryimages/meatrack_hat_fish_tropical.xml"),
	Asset("IMAGE", "images/inventoryimages/meatrack_hat_seaweed.tex"),
	Asset("ATLAS", "images/inventoryimages/meatrack_hat_seaweed.xml"),
	Asset("IMAGE", "images/inventoryimages/meatrack_hat_venus_stalk.tex"),
	Asset("ATLAS", "images/inventoryimages/meatrack_hat_venus_stalk.xml"),
	Asset("IMAGE", "images/inventoryimages/meatrack_hat_froglegs_poison.tex"),
	Asset("ATLAS", "images/inventoryimages/meatrack_hat_froglegs_poison.xml"),
	Asset("IMAGE", "images/inventoryimages/slingshot_gnasher.tex"),
	Asset("ATLAS", "images/inventoryimages/slingshot_gnasher.xml"),
	Asset("IMAGE", "images/inventoryimages/slingshot_matilda.tex"),
	Asset("ATLAS", "images/inventoryimages/slingshot_matilda.xml"),
	Asset("IMAGE", "images/inventoryimages/bagofmarbles.tex"),
	Asset("ATLAS", "images/inventoryimages/bagofmarbles.xml"),
	Asset("IMAGE", "images/inventoryimages/fishmeat_dried.tex"),
	Asset("ATLAS", "images/inventoryimages/fishmeat_dried.xml"),
	Asset("IMAGE", "images/inventoryimages/smallfishmeat_dried.tex"),
	Asset("ATLAS", "images/inventoryimages/smallfishmeat_dried.xml"),
	Asset("IMAGE", "images/inventoryimages/wixiegun.tex"),
	Asset("ATLAS", "images/inventoryimages/wixiegun.xml"),

	Asset("IMAGE", "bigportraits/wixie.tex"),
	Asset("ATLAS", "bigportraits/wixie.xml"),
	Asset("IMAGE", "bigportraits/wixie_none.tex"),
	Asset("ATLAS", "bigportraits/wixie_none.xml"),

	Asset("IMAGE", "images/names_gold_wixie.tex"),
	Asset("ATLAS", "images/names_gold_wixie.xml"),

	Asset("IMAGE", "images/map_icons/wixie.tex"),
	Asset("ATLAS", "images/map_icons/wixie.xml"),

	Asset("IMAGE", "images/avatars/avatar_wixie.tex"),
	Asset("ATLAS", "images/avatars/avatar_wixie.xml"),

	Asset("IMAGE", "images/avatars/avatar_ghost_wixie.tex"),
	Asset("ATLAS", "images/avatars/avatar_ghost_wixie.xml"),

	Asset("IMAGE", "images/avatars/self_inspect_wixie.tex"),
	Asset("ATLAS", "images/avatars/self_inspect_wixie.xml"),

	Asset("SOUNDPACKAGE", "sound/wixie.fev"),
	Asset("SOUND", "sound/wixie.fsb"),

	Asset("ATLAS", "images/claustrophobia.xml"),
	Asset("IMAGE", "images/claustrophobia.tex"),


	--CREATURES
	Asset("ANIM", "anim/voorhams.zip"),

	Asset("ANIM", "anim/um_minotaur_actions.zip"),

	Asset("ANIM", "anim/wackycocoons.zip"),
	Asset("ANIM", "anim/wackycocoonsmall.zip"), --Had to seperate into second build, too big for a single build

	Asset("ANIM", "anim/woodpecker_build.zip"),

	Asset("ANIM", "anim/um_bq_actions.zip"),
	Asset("ANIM", "anim/um_beeguard.zip"),
	Asset("ANIM", "anim/bee_mine_explode_reset.zip"),

	Asset("ANIM", "anim/uncompromising_dragonflyactions.zip"),
	Asset("ANIM", "anim/uncompromising_goosemooseactions.zip"),

	Asset("ANIM", "anim/moonmaw_dragonfly.zip"),
	Asset("ANIM", "anim/moonmaw_lavae.zip"),

	Asset("ANIM", "anim/deerclops_mutation_anims.zip"),
	Asset("ANIM", "anim/deerclops_barrier.zip"),
	Asset("ANIM", "anim/laserclops_anims.zip"),
	Asset("ANIM", "anim/deerclops_build_old.zip"), --Until I fix the anims, this'll be the solution (AXE)
	
	Asset("ANIM", "anim/nymph.zip"),

	Asset("ANIM", "anim/carnival_host_death.zip"),

	Asset("ANIM", "anim/wilton.zip"),

	Asset("ANIM", "anim/magmahound.zip"),

	Asset("ANIM", "anim/viperworm.zip"),

	Asset("ANIM", "anim/bight.zip"),
	Asset("ANIM", "anim/knook.zip"),
	Asset("ANIM", "anim/roship.zip"),
	Asset("ANIM", "anim/roship_attack.zip"),


	Asset("ANIM", "anim/rnegrabby.zip"),
	Asset("ANIM", "anim/rne_grabbylarge.zip"),
	Asset("ANIM", "anim/rnesushadow.zip"),
	Asset("ANIM", "anim/mindweaver.zip"),
	Asset("ANIM", "anim/fuelseeker.zip"),

	Asset("ANIM", "anim/figgy_newton.zip"),

	Asset("ANIM", "anim/shambler.zip"),

	Asset("ANIM", "anim/nervoustick.zip"),

	Asset("ANIM", "anim/graspingfear.zip"),

	Asset("ANIM", "anim/koalefant_scare.zip"),
	Asset("ANIM", "anim/koalefant_paw.zip"),
	Asset("ANIM", "anim/koalefant_stomp.zip"),

	Asset("ANIM", "anim/ancient_trepidation.zip"),
	Asset("ANIM", "anim/ancient_trepidation_arm.zip"),
	Asset("ANIM", "anim/ancient_trepidation_nomouth.zip"),

	Asset("ANIM", "anim/ds_pig_charge.zip"),
	Asset("ANIM", "anim/ds_pig_uppercut.zip"),

	Asset("ANIM", "anim/lazy_chester.zip"),

	Asset("ANIM", "anim/hound_jump_attack.zip"),

	Asset("ANIM", "anim/uncompromising_pawn_build.zip"),
	Asset("ANIM", "anim/uncompromising_pawn_nightmare_build.zip"),

	Asset("ANIM", "anim/krampus_bag_smack.zip"),

	Asset("ANIM", "anim/goosemoose_hopattack.zip"),
	Asset("ANIM", "anim/goosemoose_hopattack_pre.zip"),

	Asset("ANIM", "anim/dragonfly_charge_attack.zip"),
	Asset("ANIM", "anim/vomit_atk.zip"),

	Asset("ANIM", "anim/lureplague_rat.zip"),

	Asset("ANIM", "anim/snapperturtle.zip"),
	Asset("ANIM", "anim/snapperturtlebaby.zip"),

	Asset("ANIM", "anim/chomper.zip"),

	Asset("ANIM", "anim/widow1.zip"),
	Asset("ANIM", "anim/widow2.zip"),

	Asset("ANIM", "anim/sheeplet.zip"),
	Asset("ANIM", "anim/sheepletbomb.zip"),

	Asset("ANIM", "anim/aphid.zip"),
	Asset("ANIM", "anim/weevole.zip"),

	Asset("ANIM", "anim/fruitbat.zip"),

	Asset("ANIM", "anim/mushdrake_red.zip"),

	--Asset("ANIM", "anim/gatorsnake.zip"),

	Asset("ANIM", "anim/swilson.zip"),

	Asset("ANIM", "anim/stumpling.zip"),
	Asset("ANIM", "anim/birchling.zip"),

	Asset("ANIM", "anim/scorpion_basic.zip"),
	Asset("ANIM", "anim/scorpion_build.zip"),
	Asset("ANIM", "anim/scorpion_new.zip"),
	Asset("ANIM", "anim/scorpion_leave.zip"),

	Asset("ANIM", "anim/bat_vamp_build.zip"),
	Asset("ANIM", "anim/bat_vamp_shadow.zip"),

	Asset("ANIM", "anim/tree_leaf_spike_lt.zip"),

	Asset("ANIM", "anim/frog_yellow_build.zip"),

	Asset("ANIM", "anim/deerclops_ground_fx.zip"),

	Asset("ANIM", "anim/deerclopsfalling.zip"),

	Asset("ANIM", "anim/player_sneeze.zip"),

	Asset("ANIM", "anim/rhino_stun.zip"),

	Asset("ANIM", "anim/bush_crab.zip"),

	Asset("ANIM", "anim/creepingfear.zip"),

	Asset("ANIM", "anim/dreadeye.zip"),
	Asset("ANIM", "anim/dreadeye_circle.zip"),
	Asset("ANIM", "anim/shadow_eye.zip"),

	Asset("ANIM", "anim/hippo_attacks.zip"),
	Asset("ANIM", "anim/hippo_basic.zip"),
	Asset("ANIM", "anim/toadling.zip"),

	Asset("ANIM", "anim/spider_trapdoor.zip"),

	Asset("ANIM", "anim/pied_piper.zip"),

	Asset("ANIM", "anim/uncompromising_packrat_water.zip"),
	Asset("ANIM", "anim/uncompromising_packrat.zip"),

	Asset("ANIM", "anim/mosquito_yellow_build.zip"),

	Asset("ANIM", "anim/walrus_build_summer.zip"),
	Asset("ANIM", "anim/walrus_baby_build_summer.zip"),

	Asset("ANIM", "anim/gnat_cocoon.zip"),
	Asset("ANIM", "anim/pollenmites.zip"),
	Asset("ANIM", "anim/acsporecloud.zip"),

	Asset("ANIM", "anim/shadow_teleporter.zip"),

	Asset("ANIM", "anim/snapdragon.zip"),
	Asset("ANIM", "anim/snapdragon_build.zip"),
	Asset("ANIM", "anim/snapdragon_build_pale.zip"),
	Asset("ANIM", "anim/snapdragon_build_pink.zip"),
	Asset("ANIM", "anim/snapdragon_build_yellow.zip"),
	Asset("ANIM", "anim/snapdragon_build_purple.zip"),
	Asset("ANIM", "anim/snapdragon_build_red.zip"),
	Asset("ANIM", "anim/snapdragon_build_orange.zip"),
	Asset("ANIM", "anim/snapdragon_build_green.zip"),
	Asset("ANIM", "anim/snapdragon_build_neck.zip"),
	Asset("ANIM", "anim/snapdragon_build_frozen.zip"),
	Asset("ANIM", "anim/snapplant.zip"), --if it is what I remember it being, this goes here.

	Asset("ANIM", "anim/hound_lightning.zip"),
	Asset("ANIM", "anim/hound_lightning_ocean.zip"),
	Asset("ANIM", "anim/hound_spore.zip"),
	Asset("ANIM", "anim/hound_spore_ocean.zip"),
	Asset("ANIM", "anim/glacial_hound.zip"),
	Asset("ANIM", "anim/glacial_hound_ocean.zip"),

	Asset("ANIM", "anim/hippo_water_attacks.zip"),
	Asset("ANIM", "anim/hippo_water.zip"),

	Asset("ANIM", "anim/nightcrawler_build.zip"),

	Asset("ANIM", "anim/deerclops_yule_blue.zip"),
	--Asset("ANIM", "anim/yuleclops_actions_UM.zip"),
	Asset("ANIM", "anim/deerclops_laser_hit_sparks_fx_blue.zip"),
	Asset("ANIM", "anim/bearger_rockthrow.zip"),
	Asset("ANIM", "anim/bearger_build_old.zip"),


	--MISC.
	Asset("ANIM", "anim/sludgestack_short.zip"),

	Asset("ANIM", "anim/boat_repair_cork_build.zip"),

	Asset("ANIM", "anim/speaker_test.zip"),

	Asset("ANIM", "anim/siren_throne.zip"),
	
	Asset("ANIM", "anim/sunken_royalchest.zip"),
	Asset("ANIM", "anim/sunken_royalchest_rainbow.zip"),
	Asset("ANIM", "anim/sunken_royalchest_purple.zip"),
	Asset("ANIM", "anim/sunken_royalchest_red.zip"),
	Asset("ANIM", "anim/sunken_royalchest_blue.zip"),
	Asset("ANIM", "anim/sunken_royalchest_green.zip"),
	Asset("ANIM", "anim/sunken_royalchest_orange.zip"),
	Asset("ANIM", "anim/sunken_royalchest_yellow.zip"),
	Asset("ANIM", "anim/sunken_royalchest_naked.zip"),

	Asset("ANIM", "anim/driftwood_normal.zip"),

	Asset("ANIM", "anim/sorrel.zip"),

	Asset("ANIM", "anim/Bigspin.zip"),

	Asset("ANIM", "anim/um_whirlpool.zip"),

	Asset("ANIM", "anim/um_waterfall.zip"),

	Asset("ANIM", "anim/um_waterfall_pool.zip"),

	Asset("ANIM", "anim/alpha_lightning_goat_build.zip"),
	Asset("ANIM", "anim/alpha_lightning_goat_stomp.zip"),

	Asset("ANIM", "anim/marshmist.zip"),

	Asset("ANIM", "anim/ratking.zip"),
	Asset("ANIM", "anim/rattotem.zip"),
	Asset("ANIM", "anim/garbage_pile.zip"),

	Asset("ANIM", "anim/harpoon_rope.zip"),

	Asset("ANIM", "anim/armor_glassmail_shards.zip"),

	Asset("ANIM", "anim/cocoondecor.zip"),

	Asset("ANIM", "anim/skull_chest.zip"),

	Asset("ANIM", "anim/lush_grass.zip"),
	Asset("ANIM", "anim/lush_trapdoorgrass.zip"),

	Asset("ANIM", "anim/close_wardrobe.zip"),

	Asset("ANIM", "anim/guardian_splat.zip"),

	Asset("ANIM", "anim/moondialtear_build.zip"),

	Asset("ANIM", "anim/player_boat_death.zip"),
	Asset("ANIM", "anim/boat_death_shadows.zip"),
	Asset("ANIM", "anim/rne_player_grabbed.zip"),

	Asset("ANIM", "anim/player_actions_speargun.zip"),
	Asset("ANIM", "anim/player_mount_actions_speargun.zip"),

	Asset("ANIM", "anim/portableboat.zip"),
	Asset("ANIM", "anim/portableboat_test.zip"),
	Asset("ANIM", "anim/portableboat_placer.zip"),

	Asset("ANIM", "anim/lava_spitball.zip"),

	Asset("ANIM", "anim/shadowvortex.zip"),

	Asset("ANIM", "anim/um_beegun_dart.zip"),
	Asset("ANIM", "anim/um_beegun_ball.zip"),


	Asset("ANIM", "anim/glacial_hound_projectile.zip"),

	Asset("ANIM", "anim/magmaanims.zip"),

	Asset("ANIM", "anim/mothergoosemoose_nest.zip"),

	Asset("ANIM", "anim/dragonfly_egg.zip"),

	Asset("ANIM", "anim/UM_harpoonreel.zip"),

	Asset("ANIM", "anim/um_windturbine.zip"),
	Asset("ANIM", "anim/mastupgrade_windturbine.zip"),

	Asset("ANIM", "anim/trapdoorgrass.zip"),

	Asset("ANIM", "anim/bush_marsh.zip"),

	Asset("ANIM", "anim/web_net_splat.zip"),
	Asset("ANIM", "anim/web_net_splash.zip"),
	Asset("ANIM", "anim/web_net_shot.zip"),
	Asset("ANIM", "anim/web_net_trap.zip"),
	Asset("ANIM", "anim/widowwebgoop.zip"),

	Asset("ANIM", "anim/hoodedcanopy.zip"),

	Asset("ANIM", "anim/blueberryplant.zip"),

	Asset("ANIM", "anim/hooded_ferns.zip"),
	Asset("ANIM", "anim/largefern.zip"),

	Asset("ANIM", "anim/pitcher.zip"),

	Asset("ANIM", "anim/giant_tree_infested.zip"),

	Asset("ANIM", "anim/lava_vomit.zip"),

	Asset("ANIM", "anim/leif_root.zip"),
	Asset("ANIM", "anim/root_spike.zip"),
	Asset("ANIM", "anim/chop_root_spike.zip"),

	Asset("ANIM", "anim/snow_dune.zip"),
	--Asset("ANIM", "anim/sandhill.zip"),
	Asset("ANIM", "anim/snowpile.zip"),

	Asset("ANIM", "anim/tar.zip"),
	Asset("ANIM", "anim/tar_trap.zip"),

	Asset("ANIM", "anim/swap_minotaur_boulder.zip"),
	Asset("ANIM", "anim/pillar_ruins_damaged.zip"),

	Asset("ANIM", "anim/rat_note.zip"),

	Asset("ANIM", "anim/ratdroppings.zip"),

	Asset("ANIM", "anim/trapdoor.zip"),
	Asset("ANIM", "anim/rock_flipping.zip"),
	Asset("ANIM", "anim/rock_flipping_moss.zip"),

	Asset("ANIM", "anim/saltpile.zip"),

	Asset("ANIM", "anim/airconditioner.zip"),
	Asset("ANIM", "anim/air_conditioner_cloud.zip"),

	Asset("ANIM", "anim/veteranshrine.zip"),

	Asset("ANIM", "anim/walrus_house_summer.zip"),

	Asset("ANIM", "anim/critterlab_broken.zip"),

	Asset("ANIM", "anim/whisperpod_normal_ground.zip"),

	Asset("ANIM", "anim/nightmaregrowth_shrink.zip"),

	Asset("ANIM", "anim/ancient_soul_ball.zip"),

	Asset("ANIM", "anim/gems_crabclaw.zip"),

	Asset("ANIM", "anim/bearger_boulder.zip"),

	Asset("ATLAS", "images/the_men.xml"),
	Asset("IMAGE", "images/the_men.tex"),

	Asset("ATLAS", "images/tele_icon1.xml"),
	Asset("IMAGE", "images/tele_icon1.tex"),
	Asset("ATLAS", "images/tele_icon2.xml"),
	Asset("IMAGE", "images/tele_icon2.tex"),
	Asset("ATLAS", "images/tele_icon3.xml"),
	Asset("IMAGE", "images/tele_icon3.tex"),
	Asset("ATLAS", "images/tele_icon1b.xml"),
	Asset("IMAGE", "images/tele_icon1b.tex"),
	Asset("ATLAS", "images/tele_icon2b.xml"),
	Asset("IMAGE", "images/tele_icon2b.tex"),
	Asset("ATLAS", "images/tele_icon3b.xml"),
	Asset("IMAGE", "images/tele_icon3b.tex"),
	Asset("ATLAS", "images/tele_icon1c.xml"),
	Asset("IMAGE", "images/tele_icon1c.tex"),
	Asset("ATLAS", "images/tele_icon1d.xml"),
	Asset("IMAGE", "images/tele_icon1d.tex"),

	--OVERLAYS
	Asset("ATLAS", "images/UM_pollenover.xml"),
	Asset("IMAGE", "images/UM_pollenover.tex"),

	Asset("ATLAS", "images/californiakingoverlay.xml"),
	Asset("IMAGE", "images/californiakingoverlay.tex"),

	Asset("ANIM", "anim/snow_over.zip"),

	Asset("ANIM", "anim/um_storm_over.zip"),

	--FX
	Asset("ANIM", "anim/electric_explosion.zip"),

	Asset("ANIM", "anim/um_harpoonhitfx.zip"),

	Asset("ANIM", "anim/um_magneranghitfx.zip"),

	Asset("ATLAS", "images/fx5.xml"),
	Asset("IMAGE", "images/fx5.tex"),

	--
	Asset("ATLAS", "images/wixiepiano_whitekey.xml"),
	Asset("IMAGE", "images/wixiepiano_whitekey.tex"),
	Asset("ATLAS", "images/wixiepiano_blackkey.xml"),
	Asset("IMAGE", "images/wixiepiano_blackkey.tex"),
	Asset("IMAGE", "images/inventoryimages/charles_t_horse.tex"),
	Asset("ATLAS", "images/inventoryimages/charles_t_horse.xml"),
	Asset("IMAGE", "images/inventoryimages/the_real_charles_t_horse.tex"),
	Asset("ATLAS", "images/inventoryimages/the_real_charles_t_horse.xml"),

	Asset("ANIM", "anim/swap_charles_shadow.zip"),

	Asset("ANIM", "anim/uncompromising_shadow_projectile1_fx.zip"),
	Asset("ANIM", "anim/uncompromising_shadow_projectile2_fx.zip"),

	Asset("ANIM", "anim/um_spikes.zip"),
	Asset("ANIM", "anim/spikes_cookie.zip"),
	Asset("ANIM", "anim/spikes_crow.zip"),
	Asset("ANIM", "anim/spikes_goose.zip"),
	Asset("ANIM", "anim/spikes_malbatross.zip"),
	Asset("ANIM", "anim/spikes_robin.zip"),
	Asset("ANIM", "anim/spikes_robinwinter.zip"),
	Asset("ANIM", "anim/spikes_canary.zip"),

	Asset("ANIM", "anim/mara_boss1.zip"),
	Asset("ANIM", "anim/mara_boss1_bullets.zip"),
	
	-- Pyre Nettle stuff
	Asset("ANIM", "anim/um_pyre_nettles.zip"),
	Asset("ANIM", "anim/um_smolder_spore.zip"),
	Asset("ANIM", "anim/umdebuff_pyre_toxin_fx.zip"),
	Asset("ANIM", "anim/um_armor_pyre_nettles.zip"), -- This file is both a swap and a floor item. Hell if I know where to put it...so it's here!
	Asset("ANIM", "anim/um_blowdart_pyre.zip"),
	Asset("ANIM", "anim/swap_blowdart.zip"), -- Same here. Naming convention is vanilla, blame Mr. Kelly Entertainment.
	
	-- Mutation Extrapolation
	Asset("ANIM", "anim/umdebuff_moonburn_fx.zip"),
	Asset("ANIM", "anim/um_staff_meteor.zip"),
	Asset("ANIM", "anim/um_pathfinderpulse.zip"),



	--INVENTORY ITEMS [ANIMS & INV_IMAGE]
	Asset("ANIM", "anim/hat_crab.zip"),
	Asset("ANIM", "anim/staff_starfall.zip"),
	Asset("ANIM", "anim/cannonball_sludge.zip"),
	Asset("ANIM", "anim/boat_repair_cork_build.zip"),

	Asset("ANIM", "anim/ancient_amulet_red_demoneye.zip"),

	Asset("ANIM", "anim/driftwood_rod_ground.zip"),

	Asset("ANIM", "anim/oculet_ground.zip"),

	Asset("ANIM", "anim/stanton_shadow_tonic.zip"),
	Asset("ANIM", "anim/skullflask.zip"),
	Asset("ANIM", "anim/skullflask_empty.zip"),

	Asset("ANIM", "anim/um_blowguns.zip"),
	Asset("ANIM", "anim/um_darts.zip"),

	Asset("ANIM", "anim/glass_scales.zip"),
	Asset("ANIM", "anim/moonglass_geode.zip"),
	Asset("ANIM", "anim/armor_glassmail.zip"),

	Asset("INV_IMAGE", "images/inventoryimages/chester_eyebone_closed_lazy"),
	Asset("INV_IMAGE", "images/inventoryimages/chester_eyebone_lazy"),

	Asset("ANIM", "anim/hat_corvus.zip"),

	Asset("ANIM", "anim/armor_steelsweater.zip"),
	Asset("ANIM", "anim/steelsweater.zip"),

	Asset("ANIM", "anim/amulets_ancient.zip"),

	Asset("ANIM", "anim/viperfruit.zip"),

	Asset("ANIM", "anim/viperjam.zip"),

	Asset("ANIM", "anim/snotroast.zip"),

	Asset("ANIM", "anim/rne_goodiebag.zip"),

	Asset("ANIM", "anim/hat_spectremask.zip"),

	Asset("ANIM", "anim/hat_skullmask.zip"),

	Asset("ANIM", "anim/hat_redskullmask.zip"),

	Asset("ANIM", "anim/hat_pumpgoremask.zip"),

	Asset("ANIM", "anim/hat_pigmask.zip"),

	Asset("ANIM", "anim/hat_phantommask.zip"),

	Asset("ANIM", "anim/hat_orangecatmask.zip"),

	Asset("ANIM", "anim/hat_oozemask.zip"),

	Asset("ANIM", "anim/hat_mermmask.zip"),

	Asset("ANIM", "anim/hat_joyousmask.zip"),

	Asset("ANIM", "anim/hat_hockeymask.zip"),

	Asset("ANIM", "anim/hat_globmask.zip"),

	Asset("ANIM", "anim/hat_ghostmask.zip"),

	Asset("ANIM", "anim/hat_fiendmask.zip"),

	Asset("ANIM", "anim/hat_devilmask.zip"),

	Asset("ANIM", "anim/hat_wathommask.zip"),

	Asset("ANIM", "anim/hat_clownmask.zip"),

	Asset("ANIM", "anim/hat_blackcatmask.zip"),

	Asset("ANIM", "anim/hat_bagmask.zip"),

	Asset("ANIM", "anim/hat_whitecatmask.zip"),

	Asset("ANIM", "anim/hat_mandrakemask.zip"),

	Asset("ANIM", "anim/hat_technomask.zip"),

	Asset("ANIM", "anim/hat_opossummask.zip"),

	Asset("ANIM", "anim/hat_ratmask.zip"),
	Asset("ANIM", "anim/fumes_fx.zip"),

	Asset("ANIM", "anim/um_beegun.zip"),

	Asset("ANIM", "anim/boat_bumper_sludge.zip"),

	Asset("ANIM", "anim/portableboat_item.zip"),

	Asset("ANIM", "anim/corncan.zip"),

	Asset("ANIM", "anim/hat_gore_horn.zip"),

	Asset("ANIM", "anim/chester_eyebone_lazy.zip"),

	Asset("ANIM", "anim/um_trap_snare.zip"),
	Asset("ANIM", "anim/um_bear_trap_old.zip"),
	Asset("ANIM", "anim/um_bear_trap.zip"),
	Asset("ANIM", "anim/um_bear_trap_tooth.zip"),
	Asset("ANIM", "anim/um_bear_trap_gold.zip"),

	Asset("ANIM", "anim/slobberlobber.zip"),

	Asset("ANIM", "anim/beargerclaw.zip"),

	Asset("ANIM", "anim/featherfrock.zip"),
	Asset("ANIM", "anim/featherfrock_ground.zip"),
	Asset("ANIM", "anim/featherfrock_fancy.zip"),
	Asset("ANIM", "anim/featherfrock_fancy_ground.zip"),

	Asset("ANIM", "anim/um_harpoon.zip"),

	Asset("ANIM", "anim/magnerang.zip"),
	Asset("ANIM", "anim/um_magnerang_reel.zip"),

	Asset("ANIM", "anim/californiaking.zip"),

	Asset("ANIM", "anim/cursed_antler.zip"),
	Asset("ANIM", "anim/twisted_antler.zip"),

	Asset("ANIM", "anim/blueberry.zip"),

	Asset("ANIM", "anim/widowsgrasp.zip"),

	Asset("ANIM", "anim/hat_widowshead.zip"),

	Asset("ANIM", "anim/greenfoliage.zip"),

	Asset("ANIM", "anim/beefalowings.zip"),

	Asset("ANIM", "anim/snowcone.zip"),

	Asset("ANIM", "anim/scorpioncarapace.zip"),
	Asset("ANIM", "anim/scorpioncarapace_dried.zip"),

	Asset("ANIM", "anim/liceloaf.zip"),
	Asset("ANIM", "anim/stuffed_peeper_poppers.zip"),
	Asset("ANIM", "anim/seafoodpaella.zip"),
	Asset("ANIM", "anim/um_deviled_eggs.zip"),
	Asset("ANIM", "anim/zaspberryparfait.zip"),
	Asset("ANIM", "anim/blueberrypancakes.zip"),
	Asset("ANIM", "anim/devilsfruitcake.zip"),
	Asset("ANIM", "anim/simpsalad.zip"),
	Asset("ANIM", "anim/purplesteamedhams.zip"),
	Asset("ANIM", "anim/greensteamedhams.zip"),
	Asset("ANIM", "anim/hardshelltacos.zip"),

	Asset("ANIM", "anim/berniebox.zip"),

	Asset("ANIM", "anim/screecher_trinket.zip"),

	Asset("ANIM", "anim/hat_gasmask.zip"),

	Asset("ANIM", "anim/hat_snowgoggles.zip"),

	Asset("ANIM", "anim/iceboomerang.zip"),

	Asset("ANIM", "anim/diseasecurebomb.zip"),

	Asset("ANIM", "anim/um_spider_mutators.zip"),

	Asset("ANIM", "anim/pied_piper_flute.zip"),

	Asset("ANIM", "anim/rat_tail.zip"),

	Asset("ANIM", "anim/rat_fur.zip"),

	Asset("ANIM", "anim/shroom_skin_fragment.zip"),

	Asset("ANIM", "anim/saltpack.zip"),

	Asset("ANIM", "anim/snowball.zip"),

	Asset("ANIM", "anim/sporepack.zip"),

	Asset("ANIM", "anim/honey_log.zip"),

	Asset("ANIM", "anim/bugzapper.zip"),

	Asset("ANIM", "anim/plaguemask.zip"),
	Asset("ANIM", "anim/hat_plaguemask_formal.zip"),

	Asset("ANIM", "anim/hat_sunglasses.zip"),

	Asset("ANIM", "anim/moontear.zip"),

	Asset("ANIM", "anim/hat_shadowcrown.zip"),

	Asset("ANIM", "anim/whisperpod.zip"),

	Asset("ANIM", "anim/watermelon_lantern.zip"),

	Asset("ANIM", "anim/rat_whip.zip"),

	Asset("ANIM", "anim/amulet_klaus.zip"),

	Asset("ANIM", "anim/cursedcrabclaw.zip"),

	--monster morsels from waffles, thanks
	Asset("ANIM", "anim/extra_monsterfoods.zip"),
	Asset("ANIM", "anim/extra_monsterfoods_dried.zip"),

	Asset("ANIM", "anim/snapdragon_fertilizer.zip"),

	Asset("ANIM", "anim/theatercorn.zip"),

	Asset("ANIM", "anim/bulletbee_guard.zip"),
	Asset("ANIM", "anim/fatbee_guard_build.zip"),
	Asset("ANIM", "anim/hivehead_bee_guard.zip"),

	Asset("ANIM", "anim/bulletbee_build.zip"),

	Asset("ANIM", "anim/um_shadowarena.zip"),

	Asset("ANIM", "anim/trinket_wathom1.zip"),

	Asset("ANIM", "anim/winona_portables.zip"),

	--INVENTORY ITEMS [IMAGES & ATLAS]

	Asset("ATLAS", "images/inventoryimages/hat_crab.xml"),
	Asset("IMAGE", "images/inventoryimages/hat_crab.tex"),

	Asset("ATLAS", "images/inventoryimages/staff_starfall.xml"),
	Asset("IMAGE", "images/inventoryimages/staff_starfall.tex"),

	Asset("IMAGE", "images/inventoryimages/grassgekko.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/grassgekko.xml"),
	Asset("ATLAS", "images/inventoryimages/grassgekko.xml"),

	Asset("IMAGE", "images/inventoryimages/sludge_cork.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/sludge_cork.xml"),
	Asset("ATLAS", "images/inventoryimages/sludge_cork.xml"),
	Asset("IMAGE", "images/inventoryimages/um_brineishmoss.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/um_brineishmoss.xml"),
	Asset("ATLAS", "images/inventoryimages/um_brineishmoss.xml"),
	Asset("IMAGE", "images/inventoryimages/brine_balm.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/brine_balm.xml"),
	Asset("ATLAS", "images/inventoryimages/brine_balm.xml"),

	--ASSET("ATLAS_BUILD", "images/inventoryimages/cannonball_sludge_item.xml"),
	Asset("ATLAS", "images/inventoryimages/cannonball_sludge_item.xml"),
	Asset("IMAGE", "images/inventoryimages/cannonball_sludge_item.tex"),
	Asset("IMAGE", "images/inventoryimages/glass_scales.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/glass_scales.xml"),
	Asset("ATLAS", "images/inventoryimages/glass_scales.xml"),
	Asset("IMAGE", "images/inventoryimages/moonglass_geode.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/moonglass_geode.xml"),
	Asset("ATLAS", "images/inventoryimages/moonglass_geode.xml"),
	Asset("IMAGE", "images/inventoryimages/armor_glassmail.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/armor_glassmail.xml"),
	Asset("ATLAS", "images/inventoryimages/armor_glassmail.xml"),
	Asset("IMAGE", "images/inventoryimages/woodpecker.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/woodpecker.xml"),
	Asset("ATLAS", "images/inventoryimages/woodpecker.xml"),
	Asset("IMAGE", "images/inventoryimages/skullchest_child.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/skullchest_child.xml"),
	Asset("ATLAS", "images/inventoryimages/skullchest_child.xml"),
	Asset("IMAGE", "images/inventoryimages/turf_hoodedmoss.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/turf_hoodedmoss.xml"),
	Asset("ATLAS", "images/inventoryimages/turf_hoodedmoss.xml"),
	Asset("IMAGE", "images/inventoryimages/turf_ancienthoodedturf.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/turf_ancienthoodedturf.xml"),
	Asset("ATLAS", "images/inventoryimages/turf_ancienthoodedturf.xml"),
	Asset("IMAGE", "images/inventoryimages/ms_ancient_amulet_red_demoneye.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/ms_ancient_amulet_red_demoneye.xml"),
	Asset("ATLAS", "images/inventoryimages/ms_ancient_amulet_red_demoneye.xml"),
	Asset("IMAGE", "images/inventoryimages/codex_mantra.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/ancient_amulet_red_demoneye.xml"),
	Asset("ATLAS", "images/inventoryimages/codex_mantra.xml"),
	Asset("IMAGE", "images/inventoryimages/driftwoodfishingrod.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/driftwoodfishingrod.xml"),
	Asset("ATLAS", "images/inventoryimages/driftwoodfishingrod.xml"),
	Asset("IMAGE", "images/inventoryimages/uncompromising_fishingnet.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/uncompromising_fishingnet.xml"),
	Asset("ATLAS", "images/inventoryimages/uncompromising_fishingnet.xml"),
	Asset("IMAGE", "images/inventoryimages/oculet.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/oculet.xml"),
	Asset("ATLAS", "images/inventoryimages/oculet.xml"),
	Asset("IMAGE", "images/inventoryimages/stanton_shadow_tonic.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/stanton_shadow_tonic.xml"),
	Asset("ATLAS", "images/inventoryimages/stanton_shadow_tonic.xml"),
	Asset("IMAGE", "images/inventoryimages/stanton_shadow_tonic_fancy.tex"),
	Asset("ATLAS", "images/inventoryimages/stanton_shadow_tonic_fancy.xml"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/stanton_shadow_tonic_fancy.xml"),
	Asset("IMAGE", "images/inventoryimages/skullflask.tex"),
	Asset("ATLAS", "images/inventoryimages/skullflask.xml"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/skullflask.xml"),
	Asset("IMAGE", "images/inventoryimages/skullflask_empty.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/skullflask_empty.xml"),
	Asset("ATLAS", "images/inventoryimages/skullflask_empty.xml"),
	Asset("IMAGE", "images/inventoryimages/uncompromising_blowgun.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/uncompromising_blowgun.xml"),
	Asset("ATLAS", "images/inventoryimages/uncompromising_blowgun.xml"),
	Asset("IMAGE", "images/inventoryimages/blowgunammo_fire.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/blowgunammo_fire.xml"),
	Asset("ATLAS", "images/inventoryimages/blowgunammo_fire.xml"),
	Asset("IMAGE", "images/inventoryimages/blowgunammo_sleep.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/blowgunammo_sleep.xml"),
	Asset("ATLAS", "images/inventoryimages/blowgunammo_sleep.xml"),
	Asset("IMAGE", "images/inventoryimages/blowgunammo_tooth.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/blowgunammo_tooth.xml"),
	Asset("ATLAS", "images/inventoryimages/blowgunammo_tooth.xml"),
	Asset("IMAGE", "images/inventoryimages/blowgunammo_electric.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/blowgunammo_electric.xml"),
	Asset("ATLAS", "images/inventoryimages/blowgunammo_electric.xml"),

	--ASSET("ATLAS_BUILD", "images/inventoryimages/ancient_amulet_red.xml"),
	Asset("ATLAS", "images/inventoryimages/ancient_amulet_red.xml"),
	Asset("IMAGE", "images/inventoryimages/ancient_amulet_red.tex"),

	--ASSET("ATLAS_BUILD", "images/inventoryimages/rat_whip.xml"),
	Asset("ATLAS", "images/inventoryimages/rat_whip.xml"),
	Asset("IMAGE", "images/inventoryimages/rat_whip.tex"),

	Asset("IMAGE", "images/inventoryimages/klaus_amulet.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/klaus_amulet.xml"),
	Asset("ATLAS", "images/inventoryimages/klaus_amulet.xml"),

	Asset("IMAGE", "images/inventoryimages/beargerclaw.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/beargerclaw.xml"),
	Asset("ATLAS", "images/inventoryimages/beargerclaw.xml"),

	Asset("IMAGE", "images/inventoryimages/slobberlobber.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/slobberlobber.xml"),
	Asset("ATLAS", "images/inventoryimages/slobberlobber.xml"),
	Asset("IMAGE", "images/inventoryimages/um_bear_trap_equippable.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/um_bear_trap_equippable.xml"),
	Asset("ATLAS", "images/inventoryimages/um_bear_trap_equippable.xml"),
	Asset("IMAGE", "images/inventoryimages/um_bear_trap_equippable_tooth.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/um_bear_trap_equippable_tooth.xml"),
	Asset("ATLAS", "images/inventoryimages/um_bear_trap_equippable_tooth.xml"),
	Asset("IMAGE", "images/inventoryimages/um_bear_trap_equippable_gold.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/um_bear_trap_equippable_gold.xml"),
	Asset("ATLAS", "images/inventoryimages/um_bear_trap_equippable_gold.xml"),
	Asset("IMAGE", "images/inventoryimages/gore_horn_hat.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/gore_horn_hat.xml"),
	Asset("ATLAS", "images/inventoryimages/gore_horn_hat.xml"),

	Asset("IMAGE", "images/inventoryimages/corvushat.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/corvushat.xml"),
	Asset("ATLAS", "images/inventoryimages/corvushat.xml"),

	Asset("IMAGE", "images/inventoryimages/viperfruit.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/viperfruit.xml"),
	Asset("ATLAS", "images/inventoryimages/viperfruit.xml"),

	Asset("IMAGE", "images/inventoryimages/viperjam.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/viperjam.xml"),
	Asset("ATLAS", "images/inventoryimages/viperjam.xml"),

	Asset("IMAGE", "images/inventoryimages/snotroast.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/snotroast.xml"),
	Asset("ATLAS", "images/inventoryimages/snotroast.xml"),

	Asset("IMAGE", "images/inventoryimages/rne_goodiebag.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/rne_goodiebag.xml"),
	Asset("ATLAS", "images/inventoryimages/rne_goodiebag.xml"),
	Asset("IMAGE", "images/inventoryimages/hat_spectremask.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/hat_spectremask.xml"),
	Asset("ATLAS", "images/inventoryimages/hat_spectremask.xml"),
	Asset("IMAGE", "images/inventoryimages/hat_skullmask.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/hat_skullmask.xml"),
	Asset("ATLAS", "images/inventoryimages/hat_skullmask.xml"),
	Asset("IMAGE", "images/inventoryimages/hat_redskullmask.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/hat_redskullmask.xml"),
	Asset("ATLAS", "images/inventoryimages/hat_redskullmask.xml"),
	Asset("IMAGE", "images/inventoryimages/hat_pumpgoremask.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/hat_pumpgoremask.xml"),
	Asset("ATLAS", "images/inventoryimages/hat_pumpgoremask.xml"),
	Asset("IMAGE", "images/inventoryimages/hat_pigmask.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/hat_pigmask.xml"),
	Asset("ATLAS", "images/inventoryimages/hat_pigmask.xml"),
	Asset("IMAGE", "images/inventoryimages/hat_phantommask.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/hat_phantommask.xml"),
	Asset("ATLAS", "images/inventoryimages/hat_phantommask.xml"),
	Asset("IMAGE", "images/inventoryimages/hat_orangecatmask.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/hat_orangecatmask.xml"),
	Asset("ATLAS", "images/inventoryimages/hat_orangecatmask.xml"),
	Asset("IMAGE", "images/inventoryimages/hat_oozemask.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/hat_oozemask.xml"),
	Asset("ATLAS", "images/inventoryimages/hat_oozemask.xml"),
	Asset("IMAGE", "images/inventoryimages/hat_mermmask.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/hat_mermmask.xml"),
	Asset("ATLAS", "images/inventoryimages/hat_mermmask.xml"),
	Asset("IMAGE", "images/inventoryimages/hat_joyousmask.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/hat_joyousmask.xml"),
	Asset("ATLAS", "images/inventoryimages/hat_joyousmask.xml"),
	Asset("IMAGE", "images/inventoryimages/hat_hockeymask.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/hat_hockeymask.xml"),
	Asset("ATLAS", "images/inventoryimages/hat_hockeymask.xml"),
	Asset("IMAGE", "images/inventoryimages/hat_globmask.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/hat_globmask.xml"),
	Asset("ATLAS", "images/inventoryimages/hat_globmask.xml"),
	Asset("IMAGE", "images/inventoryimages/hat_ghostmask.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/hat_ghostmask.xml"),
	Asset("ATLAS", "images/inventoryimages/hat_ghostmask.xml"),
	Asset("IMAGE", "images/inventoryimages/hat_fiendmask.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/hat_fiendmask.xml"),
	Asset("ATLAS", "images/inventoryimages/hat_fiendmask.xml"),
	Asset("IMAGE", "images/inventoryimages/hat_devilmask.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/hat_devilmask.xml"),
	Asset("ATLAS", "images/inventoryimages/hat_devilmask.xml"),
	Asset("IMAGE", "images/inventoryimages/hat_wathommask.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/hat_wathommask.xml"),
	Asset("ATLAS", "images/inventoryimages/hat_wathommask.xml"),
	Asset("IMAGE", "images/inventoryimages/hat_clownmask.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/hat_clownmask.xml"),
	Asset("ATLAS", "images/inventoryimages/hat_clownmask.xml"),
	Asset("IMAGE", "images/inventoryimages/hat_blackcatmask.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/hat_blackcatmask.xml"),
	Asset("ATLAS", "images/inventoryimages/hat_blackcatmask.xml"),
	Asset("IMAGE", "images/inventoryimages/hat_bagmask.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/hat_bagmask.xml"),
	Asset("ATLAS", "images/inventoryimages/hat_bagmask.xml"),
	Asset("IMAGE", "images/inventoryimages/hat_whitecatmask.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/hat_whitecatmask.xml"),
	Asset("ATLAS", "images/inventoryimages/hat_whitecatmask.xml"),
	Asset("IMAGE", "images/inventoryimages/hat_mandrakemask.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/hat_mandrakemask.xml"),
	Asset("ATLAS", "images/inventoryimages/hat_mandrakemask.xml"),
	Asset("IMAGE", "images/inventoryimages/hat_technomask.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/hat_technomask.xml"),
	Asset("ATLAS", "images/inventoryimages/hat_technomask.xml"),
	Asset("IMAGE", "images/inventoryimages/hat_opossummask.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/hat_opossummask.xml"),
	Asset("ATLAS", "images/inventoryimages/hat_opossummask.xml"),
	Asset("IMAGE", "images/inventoryimages/hat_ratmask.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/hat_ratmask.xml"),
	Asset("ATLAS", "images/inventoryimages/hat_ratmask.xml"),

	--ASSET("ATLAS_BUILD", "images/inventoryimages/critter_figgy_builder.xml"),
	Asset("ATLAS", "images/inventoryimages/critter_figgy_builder.xml"),
	Asset("IMAGE", "images/inventoryimages/critter_figgy_builder.tex"),

	--ASSET("ATLAS_BUILD", "images/inventoryimages/portableboat_item.xml"),
	Asset("ATLAS", "images/inventoryimages/portableboat_item.xml"),
	Asset("IMAGE", "images/inventoryimages/portableboat_item.tex"),

	--ASSET("ATLAS_BUILD", "images/inventoryimages/corncan.xml"),
	Asset("ATLAS", "images/inventoryimages/corncan.xml"),
	Asset("IMAGE", "images/inventoryimages/corncan.tex"),

	Asset("IMAGE", "images/inventoryimages/nervoustick_1.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/nervoustick_1.xml"),
	Asset("ATLAS", "images/inventoryimages/nervoustick_1.xml"),
	Asset("IMAGE", "images/inventoryimages/nervoustick_2.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/nervoustick_2.xml"),
	Asset("ATLAS", "images/inventoryimages/nervoustick_2.xml"),
	Asset("IMAGE", "images/inventoryimages/nervoustick_3.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/nervoustick_3.xml"),
	Asset("ATLAS", "images/inventoryimages/nervoustick_3.xml"),
	Asset("IMAGE", "images/inventoryimages/nervoustick_4.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/nervoustick_4.xml"),
	Asset("ATLAS", "images/inventoryimages/nervoustick_4.xml"),
	Asset("IMAGE", "images/inventoryimages/nervoustick_5.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/nervoustick_5.xml"),
	Asset("ATLAS", "images/inventoryimages/nervoustick_5.xml"),
	Asset("IMAGE", "images/inventoryimages/nervoustick_6.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/nervoustick_6.xml"),
	Asset("ATLAS", "images/inventoryimages/nervoustick_6.xml"),
	Asset("IMAGE", "images/inventoryimages/nervoustick_7.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/nervoustick_7.xml"),
	Asset("ATLAS", "images/inventoryimages/nervoustick_7.xml"),
	Asset("IMAGE", "images/inventoryimages/nervoustick_8.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/nervoustick_8.xml"),
	Asset("ATLAS", "images/inventoryimages/nervoustick_8.xml"),

	--ASSET("ATLAS_BUILD", "images/inventoryimages/um_beegun.xml"),
	Asset("ATLAS", "images/inventoryimages/um_beegun.xml"),
	Asset("IMAGE", "images/inventoryimages/um_beegun.tex"),
	Asset("ATLAS", "images/inventoryimages/um_beegun_cherry.xml"),
	Asset("IMAGE", "images/inventoryimages/um_beegun_cherry.tex"),

	--ASSET("ATLAS_BUILD", "images/inventoryimages/sludge.xml"),
	Asset("ATLAS", "images/inventoryimages/sludge.xml"),
	Asset("IMAGE", "images/inventoryimages/sludge.tex"),

	--ASSET("ATLAS_BUILD", "images/inventoryimages/sludge_oil.xml"),
	Asset("ATLAS", "images/inventoryimages/sludge_oil.xml"),
	Asset("IMAGE", "images/inventoryimages/sludge_oil.tex"),

	--ASSET("ATLAS_BUILD", "images/inventoryimages/sludge_sack.xml"),
	Asset("ATLAS", "images/inventoryimages/sludge_sack.xml"),
	Asset("IMAGE", "images/inventoryimages/sludge_sack.tex"),

	--ASSET("ATLAS_BUILD", "images/inventoryimages/boatpatch_sludge.xml"),
	Asset("ATLAS", "images/inventoryimages/boatpatch_sludge.xml"),
	Asset("IMAGE", "images/inventoryimages/boatpatch_sludge.tex"),

	--ASSET("ATLAS_BUILD", "images/inventoryimages/uncompromising_harpoon_heavy.xml"),
	Asset("ATLAS", "images/inventoryimages/uncompromising_harpoon_heavy.xml"),
	Asset("IMAGE", "images/inventoryimages/uncompromising_harpoon_heavy.tex"),

	--ASSET("ATLAS_BUILD", "images/inventoryimages/rockjawleather.xml"),
	Asset("ATLAS", "images/inventoryimages/rockjawleather.xml"),
	Asset("IMAGE", "images/inventoryimages/rockjawleather.tex"),

	--ASSET("ATLAS_BUILD", "images/inventoryimages/armor_sharksuit_um.xml"),
	Asset("ATLAS", "images/inventoryimages/armor_sharksuit_um.xml"),
	Asset("IMAGE", "images/inventoryimages/armor_sharksuit_um.tex"),

	--ASSET("ATLAS_BUILD", "images/inventoryimages/boat_bumper_sludge_kit.xml"),
	Asset("ATLAS", "images/inventoryimages/boat_bumper_sludge_kit.xml"),
	Asset("IMAGE", "images/inventoryimages/boat_bumper_sludge_kit.tex"),

	--ASSET("ATLAS_BUILD", "images/inventoryimages/armor_reed_um.xml"),
	Asset("ATLAS", "images/inventoryimages/armor_reed_um.xml"),
	Asset("IMAGE", "images/inventoryimages/armor_reed_um.tex"),

	--ASSET("ATLAS_BUILD", "images/inventoryimages/boat_bumper_copper_kit.xml"),
	Asset("ATLAS", "images/inventoryimages/boat_bumper_copper_kit.xml"),
	Asset("IMAGE", "images/inventoryimages/boat_bumper_copper_kit.tex"),

	--ASSET("ATLAS_BUILD", "images/inventoryimages/um_copper_pipe.xml"),
	Asset("ATLAS", "images/inventoryimages/um_copper_pipe.xml"),
	Asset("IMAGE", "images/inventoryimages/um_copper_pipe.tex"),

	--ASSET("ATLAS_BUILD", "images/inventoryimages/powercell.xml"),
	Asset("ATLAS", "images/inventoryimages/powercell.xml"),
	Asset("IMAGE", "images/inventoryimages/powercell.tex"),

	--ASSET("ATLAS_BUILD", "images/inventoryimages/winona_toolbox.xml"),
	Asset("ATLAS", "images/inventoryimages/winona_toolbox.xml"),
	Asset("IMAGE", "images/inventoryimages/winona_toolbox.tex"),

	--ASSET("ATLAS_BUILD", "images/inventoryimages/winona_upgradekit_electrical.xml"),
	Asset("ATLAS", "images/inventoryimages/winona_upgradekit_electrical.xml"),
	Asset("IMAGE", "images/inventoryimages/winona_upgradekit_electrical.tex"),

	--ASSET("ATLAS_BUILD", "images/inventoryimages/ocupus_tentacle.xml"),
	Asset("ATLAS", "images/inventoryimages/ocupus_tentacle.xml"),
	Asset("IMAGE", "images/inventoryimages/ocupus_tentacle.tex"),

	--ASSET("ATLAS_BUILD", "images/inventoryimages/ocupus_tentacle_cooked.xml"),
	Asset("ATLAS", "images/inventoryimages/ocupus_tentacle_cooked.xml"),
	Asset("IMAGE", "images/inventoryimages/ocupus_tentacle_cooked.tex"),

	--ASSET("ATLAS_BUILD", "images/inventoryimages/ocupus_tentacle_eye.xml"),
	Asset("ATLAS", "images/inventoryimages/ocupus_tentacle_eye.xml"),
	Asset("IMAGE", "images/inventoryimages/ocupus_tentacle_eye.tex"),

	--ASSET("ATLAS_BUILD", "images/inventoryimages/ocupus_beak.xml"),
	Asset("ATLAS", "images/inventoryimages/ocupus_beak.xml"),
	Asset("IMAGE", "images/inventoryimages/ocupus_beak.tex"),

	--ASSET("ATLAS_BUILD", "images/inventoryimages/chester_eyebone_lazy.xml"),
	Asset("ATLAS", "images/inventoryimages/chester_eyebone_lazy.xml"),
	Asset("IMAGE", "images/inventoryimages/chester_eyebone_lazy.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/chester_eyebone_closed_lazy.xml"),
	Asset("ATLAS", "images/inventoryimages/chester_eyebone_closed_lazy.xml"),
	Asset("IMAGE", "images/inventoryimages/chester_eyebone_closed_lazy.tex"),

	--ASSET("ATLAS_BUILD", "images/inventoryimages/uncompromising_harpoon.xml"),
	Asset("ATLAS", "images/inventoryimages/uncompromising_harpoon.xml"),
	Asset("IMAGE", "images/inventoryimages/uncompromising_harpoon.tex"),

	--ASSET("ATLAS_BUILD", "images/inventoryimages/um_magnerang.xml"),
	Asset("ATLAS", "images/inventoryimages/um_magnerang.xml"),
	Asset("IMAGE", "images/inventoryimages/um_magnerang.tex"),

	--ASSET("ATLAS_BUILD", "images/inventoryimages/mastupgrade_windturbine_item.xml"),
	Asset("ATLAS", "images/inventoryimages/mastupgrade_windturbine_item.xml"),
	Asset("IMAGE", "images/inventoryimages/mastupgrade_windturbine_item.tex"),
	Asset("IMAGE", "images/inventoryimages/cursed_antler.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/cursed_antler.xml"),
	Asset("ATLAS", "images/inventoryimages/cursed_antler.xml"),
	Asset("IMAGE", "images/inventoryimages/ms_twisted_antler.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/ms_twisted_antler.xml"),
	Asset("ATLAS", "images/inventoryimages/ms_twisted_antler.xml"),
	Asset("IMAGE", "images/inventoryimages/seafoodpaella.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/seafoodpaella.xml"),
	Asset("ATLAS", "images/inventoryimages/seafoodpaella.xml"),
	Asset("IMAGE", "images/inventoryimages/giant_blueberry.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/giant_blueberry.xml"),
	Asset("ATLAS", "images/inventoryimages/giant_blueberry.xml"),
	Asset("IMAGE", "images/inventoryimages/widowsgrasp.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/widowsgrasp.xml"),
	Asset("ATLAS", "images/inventoryimages/widowsgrasp.xml"),

	Asset("IMAGE", "images/inventoryimages/widowshead.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/widowshead.xml"),
	Asset("ATLAS", "images/inventoryimages/widowshead.xml"),

	--ASSET("ATLAS_BUILD", "images/inventoryimages/purplesteamedhams.xml"),
	Asset("ATLAS", "images/inventoryimages/purplesteamedhams.xml"),
	Asset("IMAGE", "images/inventoryimages/purplesteamedhams.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/greensteamedhams.xml"),
	Asset("ATLAS", "images/inventoryimages/greensteamedhams.xml"),
	Asset("IMAGE", "images/inventoryimages/greensteamedhams.tex"),
	Asset("IMAGE", "images/inventoryimages/greenfoliage.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/greenfoliage.xml"),
	Asset("ATLAS", "images/inventoryimages/greenfoliage.xml"),

	--ASSET("ATLAS_BUILD", "images/inventoryimages/blueberrypancakes.xml"),
	Asset("ATLAS", "images/inventoryimages/blueberrypancakes.xml"),
	Asset("IMAGE", "images/inventoryimages/blueberrypancakes.tex"),

	--ASSET("ATLAS_BUILD", "images/inventoryimages/devilsfruitcake.xml"),
	Asset("ATLAS", "images/inventoryimages/devilsfruitcake.xml"),
	Asset("IMAGE", "images/inventoryimages/devilsfruitcake.tex"),

	--ASSET("ATLAS_BUILD", "images/inventoryimages/simpsalad.xml"),
	Asset("ATLAS", "images/inventoryimages/simpsalad.xml"),
	Asset("IMAGE", "images/inventoryimages/simpsalad.tex"),

	--ASSET("ATLAS_BUILD", "images/inventoryimages/beefalowings.xml"),
	Asset("ATLAS", "images/inventoryimages/beefalowings.xml"),
	Asset("IMAGE", "images/inventoryimages/beefalowings.tex"),

	--ASSET("ATLAS_BUILD", "images/inventoryimages/snowcone.xml"),
	Asset("ATLAS", "images/inventoryimages/snowcone.xml"),
	Asset("IMAGE", "images/inventoryimages/snowcone.tex"),

	Asset("IMAGE", "images/inventoryimages/californiaking.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/californiaking.xml"),
	Asset("ATLAS", "images/inventoryimages/californiaking.xml"),
	Asset("IMAGE", "images/inventoryimages/hardshelltacos.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/hardshelltacos.xml"),
	Asset("ATLAS", "images/inventoryimages/hardshelltacos.xml"),
	Asset("IMAGE", "images/inventoryimages/scorpioncarapace.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/scorpioncarapace.xml"),
	Asset("ATLAS", "images/inventoryimages/scorpioncarapace.xml"),
	Asset("IMAGE", "images/inventoryimages/scorpioncarapacecooked.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/scorpioncarapacecooked.xml"),
	Asset("ATLAS", "images/inventoryimages/scorpioncarapacecooked.xml"),

	Asset("IMAGE", "images/inventoryimages/liceloaf.tex"),
	----ASSET("ATLAS_BUILD", "images/inventoryimages/liceloaf.xml"),
	Asset("ATLAS", "images/inventoryimages/liceloaf.xml"),

	Asset("IMAGE", "images/inventoryimages/stuffed_peeper_poppers.tex"),
	----ASSET("ATLAS_BUILD", "images/inventoryimages/stuffed_peeper_poppers.xml"),
	Asset("ATLAS", "images/inventoryimages/stuffed_peeper_poppers.xml"),

	Asset("IMAGE", "images/inventoryimages/um_deviled_eggs.tex"),
	----ASSET("ATLAS_BUILD", "images/inventoryimages/um_deviled_eggs.xml"),
	Asset("ATLAS", "images/inventoryimages/um_deviled_eggs.xml"),

	Asset("IMAGE", "images/inventoryimages/theatercorn.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/theatercorn.xml"),
	Asset("ATLAS", "images/inventoryimages/theatercorn.xml"),

	Asset("IMAGE", "images/inventoryimages/bugzapper.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/bugzapper.xml"),
	Asset("ATLAS", "images/inventoryimages/bugzapper.xml"),

	Asset("IMAGE", "images/inventoryimages/sunglasses.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/sunglasses.xml"),
	Asset("ATLAS", "images/inventoryimages/sunglasses.xml"),

	Asset("IMAGE", "images/inventoryimages/moon_tear.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/moon_tear.xml"),
	Asset("ATLAS", "images/inventoryimages/moon_tear.xml"),

	Asset("IMAGE", "images/inventoryimages/shadow_crown.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/shadow_crown.xml"),
	Asset("ATLAS", "images/inventoryimages/shadow_crown.xml"),

	Asset("IMAGE", "images/inventoryimages/berniebox.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/berniebox.xml"),
	Asset("ATLAS", "images/inventoryimages/berniebox.xml"),

	Asset("IMAGE", "images/inventoryimages/whisperpod.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/whisperpod.xml"),
	Asset("ATLAS", "images/inventoryimages/whisperpod.xml"),

	Asset("IMAGE", "images/inventoryimages/feather_frock.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/feather_frock.xml"),
	Asset("ATLAS", "images/inventoryimages/feather_frock.xml"),
	Asset("IMAGE", "images/inventoryimages/ms_feather_frock_fancy.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/ms_feather_frock_fancy.xml"),
	Asset("ATLAS", "images/inventoryimages/ms_feather_frock_fancy.xml"),
	Asset("IMAGE", "images/inventoryimages/zaspberryparfait.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/zaspberryparfait.xml"),
	Asset("ATLAS", "images/inventoryimages/zaspberryparfait.xml"),

	----ASSET("ATLAS_BUILD", "images/inventoryimages/gasmask.xml"),
	Asset("ATLAS", "images/inventoryimages/gasmask.xml"),
	Asset("IMAGE", "images/inventoryimages/gasmask.tex"),

	--ASSET("ATLAS_BUILD", "images/inventoryimages/sand.xml"),
	--Asset("ATLAS", "images/inventoryimages/sand.xml"),
	--Asset("IMAGE", "images/inventoryimages/sand.tex"),

	--ASSET("ATLAS_BUILD", "images/inventoryimages/snowgoggles.xml"),
	Asset("ATLAS", "images/inventoryimages/snowgoggles.xml"),
	Asset("IMAGE", "images/inventoryimages/snowgoggles.tex"),

	--ASSET("ATLAS_BUILD", "images/inventoryimages/ratpoisonbottle.xml"),
	Asset("ATLAS", "images/inventoryimages/ratpoisonbottle.xml"),
	Asset("IMAGE", "images/inventoryimages/ratpoisonbottle.tex"),

	--ASSET("ATLAS_BUILD", "images/inventoryimages/iceboomerang.xml"),
	Asset("ATLAS", "images/inventoryimages/iceboomerang.xml"),
	Asset("IMAGE", "images/inventoryimages/iceboomerang.tex"),

	--ASSET("ATLAS_BUILD", "images/inventoryimages/diseasecurebomb.xml"),
	Asset("ATLAS", "images/inventoryimages/diseasecurebomb.xml"),
	Asset("IMAGE", "images/inventoryimages/diseasecurebomb.tex"),

	--ASSET("ATLAS_BUILD", "images/inventoryimages/snowball_throwable.xml"),
	Asset("ATLAS", "images/inventoryimages/snowball_throwable.xml"),
	Asset("IMAGE", "images/inventoryimages/snowball_throwable.tex"),

	--ASSET("ATLAS_BUILD", "images/inventoryimages/skeletonmeat.xml"),
	Asset("ATLAS", "images/inventoryimages/skeletonmeat.xml"),
	Asset("IMAGE", "images/inventoryimages/skeletonmeat.tex"),

	--ASSET("ATLAS_BUILD", "images/inventoryimages/critterlab_real.xml"),
	Asset("ATLAS", "images/inventoryimages/critterlab_real.xml"),
	Asset("IMAGE", "images/inventoryimages/critterlab_real.tex"),

	--ASSET("ATLAS_BUILD", "images/inventoryimages/screecher_trinket.xml"),
	Asset("ATLAS", "images/inventoryimages/screecher_trinket.xml"),
	Asset("IMAGE", "images/inventoryimages/screecher_trinket.tex"),

	--ASSET("ATLAS_BUILD", "images/inventoryimages/watermelon_lantern.xml"),
	Asset("ATLAS", "images/inventoryimages/watermelon_lantern.xml"),
	Asset("IMAGE", "images/inventoryimages/watermelon_lantern.tex"),

	--ASSET("ATLAS_BUILD", "images/inventoryimages/crabclaw.xml"),
	Asset("ATLAS", "images/inventoryimages/crabclaw.xml"),
	Asset("IMAGE", "images/inventoryimages/crabclaw.tex"),

	Asset("IMAGE", "images/inventoryimages/spider_trapdoor.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/spider_trapdoor.xml"),
	Asset("ATLAS", "images/inventoryimages/spider_trapdoor.xml"),
	Asset("IMAGE", "images/inventoryimages/pied_piper_flute.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/pied_piper_flute.xml"),
	Asset("ATLAS", "images/inventoryimages/pied_piper_flute.xml"),
	Asset("IMAGE", "images/inventoryimages/mutator_trapdoor.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/mutator_trapdoor.xml"),
	Asset("ATLAS", "images/inventoryimages/mutator_trapdoor.xml"),
	Asset("IMAGE", "images/inventoryimages/cookedmonstersmallmeat.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/cookedmonstersmallmeat.xml"),
	Asset("ATLAS", "images/inventoryimages/cookedmonstersmallmeat.xml"),
	Asset("IMAGE", "images/inventoryimages/monstersmallmeat.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/monstersmallmeat.xml"),
	Asset("ATLAS", "images/inventoryimages/monstersmallmeat.xml"),
	Asset("IMAGE", "images/inventoryimages/monstersmallmeat_dried.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/monstersmallmeat_dried.xml"),
	Asset("ATLAS", "images/inventoryimages/monstersmallmeat_dried.xml"),
	Asset("IMAGE", "images/inventoryimages/um_monsteregg.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/um_monsteregg.xml"),
	Asset("ATLAS", "images/inventoryimages/um_monsteregg.xml"),
	Asset("IMAGE", "images/inventoryimages/um_monsteregg_cooked.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/um_monsteregg_cooked.xml"),
	Asset("ATLAS", "images/inventoryimages/um_monsteregg_cooked.xml"),
	Asset("IMAGE", "images/inventoryimages/plaguemask.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/plaguemask.xml"),
	Asset("ATLAS", "images/inventoryimages/plaguemask.xml"),
	Asset("IMAGE", "images/inventoryimages/ms_hat_plaguemask_formal.tex"),
	--Asset("ATLAS_BUILD", "images/inventoryimages/ms_hat_plaguemask_formal.xml"),
	Asset("ATLAS", "images/inventoryimages/ms_hat_plaguemask_formal.xml"),
	Asset("IMAGE", "images/inventoryimages/shroom_skin_fragment.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/shroom_skin_fragment.xml"),
	Asset("ATLAS", "images/inventoryimages/shroom_skin_fragment.xml"),
	Asset("IMAGE", "images/inventoryimages/sporepack.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/sporepack.xml"),
	Asset("ATLAS", "images/inventoryimages/sporepack.xml"),

	Asset("IMAGE", "images/inventoryimages/saltpack.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/saltpack.xml"),
	Asset("ATLAS", "images/inventoryimages/saltpack.xml"),

	Asset("IMAGE", "images/inventoryimages/air_conditioner.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/air_conditioner.xml"),
	Asset("ATLAS", "images/inventoryimages/air_conditioner.xml"),

	Asset("IMAGE", "images/inventoryimages/honey_log.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/honey_log.xml"),
	Asset("ATLAS", "images/inventoryimages/honey_log.xml"),

	Asset("IMAGE", "images/inventoryimages/aphid.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/aphid.xml"),
	Asset("ATLAS", "images/inventoryimages/aphid.xml"),

	Asset("IMAGE", "images/inventoryimages/snapplant.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/snapplant.xml"),
	Asset("ATLAS", "images/inventoryimages/snapplant.xml"),

	Asset("IMAGE", "images/inventoryimages/bluegem_cracked.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/bluegem_cracked.xml"),
	Asset("ATLAS", "images/inventoryimages/bluegem_cracked.xml"),
	Asset("IMAGE", "images/inventoryimages/redgem_cracked.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/redgem_cracked.xml"),
	Asset("ATLAS", "images/inventoryimages/redgem_cracked.xml"),
	Asset("IMAGE", "images/inventoryimages/greengem_cracked.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/greengem_cracked.xml"),
	Asset("ATLAS", "images/inventoryimages/greengem_cracked.xml"),
	Asset("IMAGE", "images/inventoryimages/yellowgem_cracked.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/yellowgem_cracked.xml"),
	Asset("ATLAS", "images/inventoryimages/yellowgem_cracked.xml"),
	Asset("IMAGE", "images/inventoryimages/purplegem_cracked.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/purplegem_cracked.xml"),
	Asset("ATLAS", "images/inventoryimages/purplegem_cracked.xml"),
	Asset("IMAGE", "images/inventoryimages/orangegem_cracked.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/orangegem_cracked.xml"),
	Asset("ATLAS", "images/inventoryimages/orangegem_cracked.xml"),
	Asset("IMAGE", "images/inventoryimages/opalpreciousgem_cracked.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/opalpreciousgem_cracked.xml"),
	Asset("ATLAS", "images/inventoryimages/opalpreciousgem_cracked.xml"),
	Asset("IMAGE", "images/inventoryimages/purple_vomit.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/purple_vomit.xml"),
	Asset("ATLAS", "images/inventoryimages/purple_vomit.xml"),
	Asset("IMAGE", "images/inventoryimages/orange_vomit.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/orange_vomit.xml"),
	Asset("ATLAS", "images/inventoryimages/orange_vomit.xml"),
	Asset("IMAGE", "images/inventoryimages/yellow_vomit.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/yellow_vomit.xml"),
	Asset("ATLAS", "images/inventoryimages/yellow_vomit.xml"),
	Asset("IMAGE", "images/inventoryimages/red_vomit.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/red_vomit.xml"),
	Asset("ATLAS", "images/inventoryimages/red_vomit.xml"),
	Asset("IMAGE", "images/inventoryimages/green_vomit.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/green_vomit.xml"),
	Asset("ATLAS", "images/inventoryimages/green_vomit.xml"),
	Asset("IMAGE", "images/inventoryimages/pink_vomit.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/pink_vomit.xml"),
	Asset("ATLAS", "images/inventoryimages/pink_vomit.xml"),
	Asset("IMAGE", "images/inventoryimages/pale_vomit.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/pale_vomit.xml"),
	Asset("ATLAS", "images/inventoryimages/pale_vomit.xml"),
	Asset("IMAGE", "images/inventoryimages/red_mushed_room.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/red_mushed_room.xml"),
	Asset("ATLAS", "images/inventoryimages/red_mushed_room.xml"),
	Asset("IMAGE", "images/inventoryimages/blue_mushed_room.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/blue_mushed_room.xml"),
	Asset("ATLAS", "images/inventoryimages/blue_mushed_room.xml"),
	Asset("IMAGE", "images/inventoryimages/green_mushed_room.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/green_mushed_room.xml"),
	Asset("ATLAS", "images/inventoryimages/green_mushed_room.xml"),
	Asset("IMAGE", "images/inventoryimages/rat_tail.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/rat_tail.xml"),
	Asset("ATLAS", "images/inventoryimages/rat_tail.xml"),

	Asset("IMAGE", "images/inventoryimages/bulletbee.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/bulletbee.xml"),
	Asset("ATLAS", "images/inventoryimages/bulletbee.xml"),

	Asset("IMAGE", "images/inventoryimages/cherrybulletbee.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/cherrybulletbee.xml"),
	Asset("ATLAS", "images/inventoryimages/cherrybulletbee.xml"),
	Asset("IMAGE", "images/inventoryimages/um_ornament_opossum.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/um_ornament_opossum.xml"),
	Asset("ATLAS", "images/inventoryimages/um_ornament_opossum.xml"),
	Asset("IMAGE", "images/inventoryimages/um_ornament_rat.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/um_ornament_rat.xml"),
	Asset("ATLAS", "images/inventoryimages/um_ornament_rat.xml"),
	Asset("IMAGE", "images/inventoryimages/trinket_wathom1.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/trinket_wathom1.xml"),
	Asset("ATLAS", "images/inventoryimages/trinket_wathom1.xml"),
	Asset("IMAGE", "images/inventoryimages/wooden_queen_piece.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/wooden_queen_piece.xml"),
	Asset("ATLAS", "images/inventoryimages/wooden_queen_piece.xml"),
	Asset("IMAGE", "images/inventoryimages/wixie_piano_card.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/wixie_piano_card.xml"),
	Asset("ATLAS", "images/inventoryimages/wixie_piano_card.xml"),
	Asset("IMAGE", "images/inventoryimages/winona_battery_low_item.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/winona_battery_low_item.xml"),
	Asset("ATLAS", "images/inventoryimages/winona_battery_low_item.xml"),
	Asset("IMAGE", "images/inventoryimages/winona_battery_high_item.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/winona_battery_high_item.xml"),
	Asset("ATLAS", "images/inventoryimages/winona_battery_high_item.xml"),
	Asset("IMAGE", "images/inventoryimages/winona_spotlight_item.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/winona_spotlight_item.xml"),
	Asset("ATLAS", "images/inventoryimages/winona_spotlight_item.xml"),
	Asset("IMAGE", "images/inventoryimages/winona_catapult_item.tex"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/winona_catapult_item.xml"),
	Asset("ATLAS", "images/inventoryimages/winona_catapult_item.xml"),
	
	Asset("ATLAS", "images/inventoryimages/um_smolder_spore.xml"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/um_smolder_spore.xml"),
	Asset("IMAGE", "images/inventoryimages/um_smolder_spore.tex"),
	
	Asset("ATLAS", "images/inventoryimages/um_blowdart_pyre.xml"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/um_blowdart_pyre.xml"),
	Asset("IMAGE", "images/inventoryimages/um_blowdart_pyre.tex"),
	
	Asset("ATLAS", "images/inventoryimages/um_armor_pyre_nettles.xml"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/um_armor_pyre_nettles.xml"),
	Asset("IMAGE", "images/inventoryimages/um_armor_pyre_nettles.tex"),
	
	Asset("ATLAS", "images/inventoryimages/um_staff_meteor.xml"),
	--ASSET("ATLAS_BUILD", "images/inventoryimages/um_staff_meteor.xml"),
	Asset("IMAGE", "images/inventoryimages/um_staff_meteor.tex"),
	
	

	--SWAPS
	Asset("ANIM", "anim/swap_driftwood_fishingrod.zip"),
	Asset("ANIM", "anim/torso_amulets_klaus.zip"), --Not quite sure...
	Asset("ANIM", "anim/swap_hat_crab.zip"),
	Asset("ANIM", "anim/swap_staff_starfall.zip"),
	Asset("ANIM", "anim/torso_amulets_ancient.zip"),
	Asset("ANIM", "anim/torso_ancient_amulet_red_demoneye.zip"),

	Asset("ANIM", "anim/oculet.zip"),

	Asset("ANIM", "anim/swap_driftwood_fishingrod.zip"),

	Asset("ANIM", "anim/swap_um_beegun.zip"),
	Asset("ANIM", "anim/swap_um_beegun_cherry.zip"),

	Asset("ANIM", "anim/hat_gore_horn_swap_on.zip"),
	Asset("ANIM", "anim/hat_gore_horn_swap_off.zip"),

	Asset("ANIM", "anim/swap_um_beartrap.zip"),
	Asset("ANIM", "anim/swap_um_beartrap_tooth.zip"),
	Asset("ANIM", "anim/swap_um_beartrap_gold.zip"),

	Asset("ANIM", "anim/swap_snowball_throwable.zip"),

	Asset("ANIM", "anim/swap_sporepack.zip"),

	Asset("ANIM", "anim/swap_iceboomerang.zip"),

	Asset("ANIM", "anim/swap_saltpack.zip"),

	Asset("ANIM", "anim/swap_diseasecurebomb.zip"),

	Asset("ANIM", "anim/swap_bugzapper.zip"),

	Asset("ANIM", "anim/swap_nightstick_off.zip"),

	Asset("ANIM", "anim/swap_rat_whip.zip"),

	Asset("ANIM", "anim/swap_crabclaw.zip"),

	Asset("ANIM", "anim/swap_cursed_antler.zip"),

	Asset("ANIM", "anim/swap_twisted_antler.zip"),

	Asset("ANIM", "anim/swap_widowsgrasp.zip"),

	Asset("ANIM", "anim/swap_slobberlobber.zip"),

	Asset("ANIM", "anim/swap_beargerclaw.zip"),

	Asset("ANIM", "anim/swap_um_harpoon.zip"),

	Asset("ANIM", "anim/swap_magnerang.zip"),
	
	Asset("ANIM", "anim/swap_um_staff_meteor.zip"),

	Asset("ANIM", "anim/winona_toolbox.zip"),
	Asset("ANIM", "anim/winona_upgradekit_electrical.zip"),

	Asset("ANIM", "anim/um_goo_honey.zip"),

	Asset("ANIM", "anim/um_alpha_lightninggoat.zip"),

	--UI
	Asset("IMAGE", "images/dragonflycontainerborder.tex"),
	Asset("ATLAS", "images/dragonflycontainerborder.xml"),

	Asset("ANIM", "anim/acid_meter.zip"),

	Asset("ATLAS", "images/mushroom_slot.xml"),
	Asset("IMAGE", "images/mushroom_slot.tex"),

	Asset("ATLAS", "images/wardrobe_tool_slot.xml"),
	Asset("IMAGE", "images/wardrobe_tool_slot.tex"),

	Asset("ATLAS", "images/wardrobe_hat_slot.xml"),
	Asset("IMAGE", "images/wardrobe_hat_slot.tex"),

	Asset("ATLAS", "images/wardrobe_chest_slot.xml"),
	Asset("IMAGE", "images/wardrobe_chest_slot.tex"),

	Asset("ATLAS", "images/gem_slot.xml"),
	Asset("IMAGE", "images/gem_slot.tex"),

	Asset("ATLAS", "images/feather_slot.xml"),
	Asset("IMAGE", "images/feather_slot.tex"),

	Asset("ATLAS", "images/fish_slot.xml"),
	Asset("IMAGE", "images/fish_slot.tex"),

	Asset("ATLAS", "images/bee_slot.xml"),
	Asset("IMAGE", "images/bee_slot.tex"),

	Asset("ANIM", "anim/um_status_wx.zip"),



	--ICONS
	Asset("IMAGE", "images/vetskull.tex"),
	Asset("ATLAS", "images/vetskull.xml"),

	Asset("IMAGE", "images/UM_TT.tex"),
	Asset("ATLAS", "images/UM_TT.xml"),

	Asset("IMAGE", "images/PP_TT.tex"),
	Asset("ATLAS", "images/PP_TT.xml"),

	Asset("IMAGE", "images/engineering_tip.tex"),
	Asset("ATLAS", "images/engineering_tip.xml"),

	--SOUND
	Asset("SOUNDPACKAGE", "sound/UCSounds.fev"),
	Asset("SOUND", "sound/UCSounds_bank00.fsb"),

	Asset("SOUNDPACKAGE", "sound/UMMusic.fev"),
	Asset("SOUND", "sound/UMMusic.fsb"),

	Asset("SOUNDPACKAGE", "sound/tiddle_stranger.fev"),
	Asset("SOUND", "sound/tiddle_stranger.fsb"),
	
	Asset("SOUNDPACKAGE", "sound/stmpwyfs.fev"),
	Asset("SOUND", "sound/stmpwyfs.fsb"),



	--MAP ICONS
	Asset("IMAGE", "images/map_icons/riceplant.tex"),
	Asset("ATLAS", "images/map_icons/riceplant.xml"),

	Asset("IMAGE", "images/map_icons/sporepack_map.tex"),
	Asset("ATLAS", "images/map_icons/sporepack_map.xml"),

	Asset("IMAGE", "images/map_icons/air_conditioner_map.tex"),
	Asset("ATLAS", "images/map_icons/air_conditioner_map.xml"),
	Asset("IMAGE", "images/map_icons/blueberryplant_map.tex"),
	Asset("ATLAS", "images/map_icons/blueberryplant_map.xml"),

	Asset("IMAGE", "images/map_icons/giant_tree.tex"),
	Asset("ATLAS", "images/map_icons/giant_tree.xml"),

	Asset("IMAGE", "images/map_icons/pitcher.tex"),
	Asset("ATLAS", "images/map_icons/pitcher.xml"),

	Asset("IMAGE", "images/map_icons/snapplant_map.tex"),
	Asset("ATLAS", "images/map_icons/snapplant_map.xml"),

	Asset("IMAGE", "images/map_icons/veteranshrine_map.tex"),
	Asset("ATLAS", "images/map_icons/veteranshrine_map.xml"),

	Asset("IMAGE", "images/map_icons/lazychester_minimap.tex"),
	Asset("ATLAS", "images/map_icons/lazychester_minimap.xml"),

	Asset("IMAGE", "images/map_icons/hoodedwidow_map.tex"),
	Asset("ATLAS", "images/map_icons/hoodedwidow_map.xml"),

	Asset("IMAGE", "images/map_icons/pollenmiteden_map.tex"),
	Asset("ATLAS", "images/map_icons/pollenmiteden_map.xml"),

	Asset("IMAGE", "images/map_icons/um_pawn.tex"),
	Asset("ATLAS", "images/map_icons/um_pawn.xml"),

	Asset("IMAGE", "images/map_icons/um_pawn_nightmare.tex"),
	Asset("ATLAS", "images/map_icons/um_pawn_nightmare.xml"),
	Asset("IMAGE", "images/map_icons/uncompromising_ratburrow.tex"),
	Asset("ATLAS", "images/map_icons/uncompromising_ratburrow.xml"),
	Asset("IMAGE", "images/map_icons/uncompromising_winkyhomeburrow.tex"),
	Asset("ATLAS", "images/map_icons/uncompromising_winkyhomeburrow.xml"),
	Asset("IMAGE", "images/map_icons/sludge_sack.tex"),
	Asset("ATLAS", "images/map_icons/sludge_sack.xml"),

	--Asset("IMAGE", "images/map_icons/sludge_stack.tex"),
	--Asset("ATLAS", "images/map_icons/sludge_stack.xml"),

	--Asset("IMAGE", "images/map_icons/winonas_toolbox.tex"),
	--Asset("ATLAS", "images/map_icons/winonas_toolbox.xml"),

	--Asset("IMAGE", "images/map_icons/inflatable_raft.tex"),
	--Asset("ATLAS", "images/map_icons/inflatable_raft.xml"),

	--Asset("IMAGE", "images/map_icons/boomberry.tex"),
	--Asset("ATLAS", "images/map_icons/boomberry.xml"),

	Asset("IMAGE", "images/map_icons/telebase_active.tex"),
	Asset("ATLAS", "images/map_icons/telebase_active.xml"),
	
	Asset("IMAGE", "images/map_icons/um_pyre_nettles_map.tex"),
	Asset("ATLAS", "images/map_icons/um_pyre_nettles_map.xml"),
	
	Asset("IMAGE", "images/map_icons/um_tornado_map.tex"),
	Asset("ATLAS", "images/map_icons/um_tornado_map.xml"),

	--BIGPORTRAITS
	Asset("IMAGE", "bigportraits/willow.tex"),
	Asset("ATLAS", "bigportraits/willow.xml"),
	Asset("IMAGE", "bigportraits/willow_none.tex"),
	Asset("ATLAS", "bigportraits/willow_none.xml"),


    --FX TEXTURES

    Asset("IMAGE", "fx/smog1.tex"),
    Asset("IMAGE", "fx/smog2.tex"),
    Asset("IMAGE", "fx/smog3.tex"),
    Asset("IMAGE", "fx/smog4.tex"),

}
