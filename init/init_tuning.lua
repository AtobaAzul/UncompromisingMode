local function RGB(r, g, b)
    return { r / 255, g / 255, b / 255, 1 }
end


local seg_time = 30

local day_segs = 10
local dusk_segs = 4
local night_segs = 2

local day_time = seg_time * day_segs
local total_day_time = seg_time * 16
local wilson_attack = 34
local day_time = seg_time * day_segs
local dusk_time = seg_time * dusk_segs
local night_time = seg_time * night_segs
local multiplayer_armor_durability_modifier = 0.7
local multiplayer_armor_absorption_modifier = 1

TUNING = GLOBAL.TUNING

-- [              DSTU Related Overrides                  ]

local ia_check = GLOBAL.KnownModIndex:IsModEnabled("workshop-1467214795")

TUNING.DSTU =
{
    ----------------------------------------------------------------------------
    --Armor
    ----------------------------------------------------------------------------
    ARMORREED_UM = TUNING.WILSON_HEALTH * 2.1 * multiplayer_armor_durability_modifier,
    ----------------------------------------------------------------------------
    --Acid colour
    ----------------------------------------------------------------------------
    ACID_TEXT_COLOUR = RGB(180, 200, 0),
    ----------------------------------------------------------------------------
    --Food changes
    ----------------------------------------------------------------------------
    --Global appearance rate of foods
    FOOD_CARROT_PLANTED_APPEARANCE_PERCENT = 0.75,
    FOOD_BERRY_NORMAL_APPEARANCE_PERCENT = 0.6,
    FOOD_BERRY_JUICY_APPEARANCE_PERCENT = 0.6,
    FOOD_MUSHROOM_GREEN_APPEARANCE_PERCENT = 0.65,
    FOOD_MUSHROOM_BLUE_APPEARANCE_PERCENT = 0.6,
    FOOD_MUSHROOM_RED_APPEARANCE_PERCENT = 0.7,
    --Growth time increases
    STONE_FRUIT_GROWTH_INCREASE = 3,
    TREE_GROWTH_TIME_INCREASE = 1.05,
    BERRYBUSH_JUICY_CYCLES = 2,
    --Food stats
    FOOD_BUTTERFLY_WING_HEALTH = 1,
    FOOD_BUTTERFLY_WING_HUNGER = 2.5,
    FOOD_BUTTERFLY_WING_PERISHTIME = total_day_time / 2,
    FOOD_SPOILED_FOOD_HEALTH = -5,
    FOOD_SPOILED_FOOD_SANITY = -5,
    FOOD_SEEDS_HUNGER = 1.5,
    --Food production
    FOOD_HONEY_PRODUCTION_PER_STAGE = { 0, 1, 2, 4 },
    --Respawn time increases
    BUNNYMAN_RESPAWN_TIME_DAYS = 3,
    ----------------------------------------------------------------------------
    --Winter Fire spreading
    ----------------------------------------------------------------------------
    WINTER_FIRE_MOD = 0.65,
    ----------------------------------------------------------------------------
    --Acid rain event tuning
    ----------------------------------------------------------------------------
    ACID_RAIN_DAMAGE_TICK = 2,
    ACID_RAIN_START_AFTER_DAY = 70,
    ACID_RAIN_DISEASE_CHANCE = 0.1, --each 5-10 seconds
    TOADSTOOL_ACIDMUSHROOM = {
        RADIUS = 2.5,
        WAVE_MAX_ATTACKS = 7,
        WAVE_MIN_ATTACKS = 5,
        WAVE_ATTACK_DELAY = .75,
        WAVE_ATTACK_DELAY_VARIANCE = 1,
        WAVE_MERGE_ATTACKS_DIST_SQ = math.pow(4 * 3, 2), -- 4 == TILE_SCALE
        NUM_WARNINGS = 12,
        WARNING_DELAY = 1,
        WARNING_DELAY_VARIANCE = .3,
    },
    ----------------------------------------------------------------------------
    --Clothing Degredation and Sewing Kit Changes
    ----------------------------------------------------------------------------
    CLOTHINGDEGREDATION = GetModConfigData("durability"),
    SEWING_KIT = GetModConfigData("sewingkit"),
    ----------------------------------------------------------------------------
    --Flingo Change
    ----------------------------------------------------------------------------
    FLINGO_SETTING = GetModConfigData("flingo_setting"),
    ----------------------------------------------------------------------------
    --Sleeping Change
    ----------------------------------------------------------------------------
    GOTOBED = GetModConfigData("gotobed"),
    SLEEPINGBUFF = GetModConfigData("sleepingbuff"),
    ----------------------------------------------------------------------------
    --Cooking recipe changes
    ----------------------------------------------------------------------------
    --Recipe stat changes
    RECIPE_CHANGE_STEW_COOKTIME = 180, --in seconds
    --RECIPE_CHANGE_PEROGI_PERISH = TUNING.PERISH_MED, --in days (from 20 to 10)
    RECIPE_CHANGE_BACONEGG_PERISH = TUNING.PERISH_MED,
    RECIPE_CHANGE_MEATBALL_HUNGER = TUNING.CALORIES_SMALL * 4, -- (12.5 * 4) = 50, from 62.5
    --Limits to fillers
    CROCKPOT_RECIPE_TWIG_LIMIT = 1,
    CROCKPOT_RECIPE_ICE_LIMIT = 1,
    CROCKPOT_RECIPE_ICE_PLUS_TWIG_LIMIT = 1,
    --Monster meat meat dilution
    MONSTER_MEAT_RAW_MONSTER_VALUE = 2.5,    --3
    MONSTER_MEAT_COOKED_MONSTER_VALUE = 2.0, --2.5
    MONSTER_MEAT_DRIED_MONSTER_VALUE = 1.5,  --2
    MONSTER_MEAT_MEAT_REDUCTION_PER_MEAT = 1.0,
    ----------------------------------------------------------------------------
    --Recipe changes
    ----------------------------------------------------------------------------
    --Celestial portal costs
    RECIPE_MOONROCK_IDOL_MOONSTONE_COST = 5,
    RECIPE_CELESTIAL_UPGRADE_GLASS_COST = 20,
    ----------------------------------------------------------------------------
    --Food Changes Config
    ----------------------------------------------------------------------------

    --Crockpot Recipes
    CROCKPOTMONSTMEAT = GetModConfigData("crockpotmonstmeat"),
    GENERALCROCKBLOCKER = GetModConfigData("generalcrockblocker"),
    ICECROCKBLOCKER = GetModConfigData("icecrockblocker"),
    --Crockpot Dish Changes

    MEATBALL = GetModConfigData("meatball"),
    PIEROGI = GetModConfigData("perogi"),
    FARMFOODREDUX = GetModConfigData("farmfoodredux"),
    ICECREAMBUFF = GetModConfigData("icecreambuff"),
    ----------------------------------------------------------------------------
    --Mob changes
    ----------------------------------------------------------------------------
    --ratraid
    RATRAID_TIMERSTART = GetModConfigData("rattimer"),
    RATRAID_GRACE = GetModConfigData("ratgrace"),
    RATSNIFFER_TIMER = GetModConfigData("ratsnifftimer_"),
    --Generics
    MONSTER_BAT_CAVE_NR_INCREASE = 3,
    CAVE_ENTRANCE_BATS_SPAWN_PERIOD_UM = 0.8,
    MONSTER_CATCOON_HEALTH_CHANGE = TUNING.CATCOON_LIFE * 2.5,
    --Mctusk
    MONSTER_MCTUSK_HEALTH_INCREASE = 3,
    MONSTER_MCTUSK_HOUND_NUMBER = 5,
    --Hounds
    MONSTER_HOUNDS_PER_WAVE_INCREASE = 1.5, --Controlled by player settings
    --Hooded Widow
    WIDOW_HEALTH = GetModConfigData("widow health"),
    --Mother Goose
    MOTHER_GOOSE_HEALTH = GetModConfigData("mother goose health"),
    --Wiltfly Health
    WILTFLY_HEALTH = GetModConfigData("wiltfly health"),
    --Spawn New Bosses
    SPAWNMOTHERGOOSE = GetModConfigData("mother_goose"),
    SPAWNWILTINGFLY = GetModConfigData("wiltfly"),
    --Hound inclusion
    SPOREHOUNDS = GetModConfigData("sporehounds"),
    GLACIALHOUNDS = GetModConfigData("glacialhounds"),
    LIGHTNINGHOUNDS = GetModConfigData("lightninghounds"),
    MAGMAHOUNDS = GetModConfigData("magmahounds"),
    FIREBITEHOUNDS = GetModConfigData("firebitehounds"),
    FROSTBITEHOUNDS = GetModConfigData("frostbitehounds"),
    VARGWAVES = false,           --GetModConfigData("vargwaves"),
    VARGWAVES_BOSS_GRACE = 15,   --GetModConfigData("vargwaves grace"),
    VARGWAVES_DELAY_PERIOD = 15, --GetModConfigData("vargwaves delay"),
    LATEGAMEHOUNDSPREAD = GetModConfigData("lategamehoundspread"),
    --Worm inclusion
    DEPTHSEELS = GetModConfigData("depthseels"),
    DEPTHSVIPERS = GetModConfigData("depthsvipers"),
    --Bats
    ADULTBATILISKS = GetModConfigData("adultbatilisks"),
    BATSPOOKING = GetModConfigData("batspooking"),
    --Scorpions
    DESERTSCORPIONS = GetModConfigData("desertscorpions"),
    --Pinelings
    PINELINGS = GetModConfigData("pinelings"),
    --Ancient Trepidations
    TREPIDATIONS = GetModConfigData("trepidations"),
    --Pawns
    PAWNS = GetModConfigData("pawns"),
    --Spiders
    REGSPIDERJUMP = GetModConfigData("alljumperspiders"),
    SPIDERWARRIORCOUNTER = GetModConfigData("spiderwarriorcounter"),
    TRAPDOORSPIDERS = GetModConfigData("trapdoorspiders"),
    --Perishable Increase
    PERISHABLETIME = GetModConfigData("more perishing"),
    --Fire Loot Rework
    FIRELOOT = GetModConfigData("fireloot"),
    POLLENMITES = GetModConfigData("pollenmites"),
    ----------------------------------------------------------------------------
    --Player changes
    ----------------------------------------------------------------------------


    --Tripover chance on walking with 100 wetness (depricated)
    TRIPOVER_HEALTH_DAMAGE           = 10,
    TRIPOVER_ONMAXWET_CHANCE_PER_SEC = 0.10,
    TRIPOVER_KNOCKABCK_RADIUS        = 2,
    TRIPOVER_ONMAXWET_COOLDOWN       = 5,
    --Weapon slip increase
    SLIPCHANCE_INCREASE_X            = 3,
    NIGHTSTICK_FUEL                  = 240,
    WET_FUEL_PENALTY                 = 0.20,
    ----------------------------------------------------------------------------
    --Character changes
    ----------------------------------------------------------------------------
    --Woodie
    GOOSE_WATER_WETNESS_RATE         = 3,
    WOODIE                           = GetModConfigData("woodie"),
    --Wolfgang
    WOLFGANG_SANITY_MULTIPLIER       = 1.3, --prev was 1.1
    WOLFGANG_HUNGERMIGHTY            = GetModConfigData("wolfgang"),
    --WX78
    WX78_MOISTURE_DAMAGE_INCREASE    = 3,
    WX78_CONFIG                      = GetModConfigData("wx78"),
    --Wormwood
    WORMWOOD_BURN_TIME               = 6.66, --orig 4.3
    WORMWOOD_FIRE_DAMAGE             = 1.75, -- orig 1.25
    WORMWOOD_CONFIG_FIRE             = GetModConfigData("wormwood_fire"),
    WORMWOOD_CONFIG_PLANTS           = GetModConfigData("wormwood_plants"),
    --Warly
    WARLY_SAME_OLD_COOLDOWN          = total_day_time * 3,
    WARLY_SAME_OLD_MULTIPLIERS       = { .6, .5, .35, .2, .1 },
    --Wigfrid
    BATTLESONG_FIRE_RESIST_MOD       = 0, --orig 33% fire resis
    --Maxwell
    SHADOWWAXWELL_FUEL_COST          = 2,
    SHADOWWAXWELL_HEALTH_COST        = 15,
    OLD_SHADOWWAXWELL_SANITY_COST    = 55,
    OLD_SHADOWWAXWELL_SANITY_PENALTY = .275,
    OLD_SHADOWWAXWELL                = GetModConfigData("waxwell"),
    --Winona
    WINONA_WORKER                    = GetModConfigData("winonaworker"),
    WINONA_WACKCATS                  = GetModConfigData("winonawackycats"),
    --Wickerbottom
    WICKERNERF                       = GetModConfigData("wickerbottom"),
    WICKERNERF_TENTACLES             = GetModConfigData("on tentacles"),
    WICKERNERF_HORTICULTURE          = GetModConfigData("applied horticulture"),
    WICKERNERF_BEEBOOK               = GetModConfigData("apicultural notes"),
    WICKERNERF_MOONBOOK              = GetModConfigData("lunar grimoire"),
    --Wanda
    WANDA_NERF                       = GetModConfigData("wanda_nerf"),
    --Wortox
    WORTOX                           = GetModConfigData("wortox"),
    --Mobs
    RAIDRAT_HEALTH                   = 100,
    RAIDRAT_DAMAGE                   = 20,
    RAIDRAT_ATTACK_PERIOD            = 2.5,
    RAIDRAT_BUFFED_ATTACK_PERIOD     = 1.5,
    RAIDRAT_ATTACK_RANGE             = 1,
    RAIDRAT_RUNSPEED                 = 8,
    RAIDRAT_BUFFED_RUNSPEED          = 10,
    RAIDRAT_WALKSPEED                = 4,
    RAIDRAT_BUFFED_WALKSPEED         = 6,
    RAIDRAT_SPAWNRATE                = seg_time / 5,
    RAIDRAT_SPAWNRATE_VARIANCE       = (seg_time / 5) * 0.5,
    PIEDPIPER_TOOT_RANGE             = 25,
    --Weather Start Date
    WEATHERHAZARD_START_DATE_AUTUMN  = GetModConfigData("weatherhazard_autumn"),
    WEATHERHAZARD_START_DATE_WINTER  = GetModConfigData("weatherhazard_winter"),
    WEATHERHAZARD_START_DATE_SPRING  = GetModConfigData("weatherhazard_spring"),
    --WEATHERHAZARD_START_DATE_SUMMER = GetModConfigData("weatherhazard_summer"),
    RNE_CHANCE                       = GetModConfigData("rne chance"),
    SNOWSTORMS                       = GetModConfigData("snowstorms"),
    HARDER_SHADOWS                   = GetModConfigData("harder_shadows"),
    MAX_DISTANCE_TO_SHADOWS          = 1225, -- 35^2
    CREEPINGFEAR_SPEED               = 4.8,
    CREEPINGFEAR_HEALTH              = 1600,
    CREEPINGFEAR_DAMAGE              = 60,
    CREEPINGFEAR_ATTACK_PERIOD       = 2.3,
    CREEPINGFEAR_RANGE_1             = 3.0,
    CREEPINGFEAR_RANGE_2             = 4.0, --4.2,
    CREEPINGFEAR_SPAWN_THRESH        = 0,   -- 10%
    CREEPINGFEAR_WALK_SPEED          = 5,
    CREEPINGFEAR_RUN_SPEED           = 6,
    DREADEYE_SPEED                   = 7,
    DREADEYE_HEALTH                  = 350,
    DREADEYE_DAMAGE                  = 35,
    DREADEYE_ATTACK_PERIOD           = 6,
    DREADEYE_RANGE_1                 = 13,
    DREADEYE_RANGE_2                 = 2.5,
    DREADEYE_SPAWN_THRESH            = 0.50,
    MINI_DREADEYE_HEALTH             = 100,
    MOCK_DRAGONFLY_DAMAGE            = 125,
    TOADLING_DAMAGE                  = 50,
    TOADLING_HEALTH                  = 1000,
    TOADLING_ATTACK_PERIOD           = 2,
    TOADLING_WALK_SPEED              = 5,
    TOADLING_RUN_SPEED               = 6,
    TOADLING_TARGET_DIST             = 12,
    BAT_HEALTH                       = 75,
    TOAD_RAIN_DELAY                  = { min = 5, max = 10 },
    SUMMER_CAVES_TEMP_MULT           = 0.85,
    WINTER_CAVES_TEMP_MULT           = 1.25,
    --SNAPDRAGON FERTILIZER VALUES
    PURPLE_VOMIT_NUTRIENTS           = { 16, 16, 0 },
    ORANGE_VOMIT_NUTRIENTS           = { 0, 16, 16 },
    YELLOW_VOMIT_NUTRIENTS           = { 16, 0, 16 },
    RED_VOMIT_NUTRIENTS              = { 0, 24, 0 },
    GREEN_VOMIT_NUTRIENTS            = { 0, 0, 24 },
    PINK_VOMIT_NUTRIENTS             = { 24, 0, 0 },
    PALE_VOMIT_NUTRIENTS             = { 8, 8, 8 },
    --Experimental and DEV

    ELECTRICALMISHAP                 = GetModConfigData("electricalmishap"),
    ANNOUNCE_BASESTATUS              = GetModConfigData("announce_basestatus"),
    EYEBRELLAREWORK                  = GetModConfigData("eyebrellarework"),
    --More Config
    UPDATE_CHECK                     = CurrentRelease.GreaterOrEqualTo("R25_REFRESH_WAXWELL"), --REMEMBER TO ALWAYS UPDATE THIS WITH NEW BETAS.
    POCKET_POWERTRIP                 = GetModConfigData("pocket_powertrip"),
    WINTER_BURNING                   = GetModConfigData("winter_burning"),
    HUNGRY_VOID                      = GetModConfigData("hungry_void"),
    BUTTERFLYWINGS_NERF              = GetModConfigData("butterflywings_nerf"),
    LONGPIG                          = GetModConfigData("longpig"),
    RAW_CROPS_NERF                   = GetModConfigData("rawcropsnerf"),
    WENDY_NERF                       = GetModConfigData("wendy"),
    TOADS                            = GetModConfigData("toads"),
    MONSTER_EGGS                     = GetModConfigData("monstereggs"),
    IMPASSBLES                       = GetModConfigData("passibleimpassibles"),
    VETCURSE                         = GetModConfigData("vetcurse"),
    MOON_TRANSFORMATIONS             = GetModConfigData("moon_transformations"),
    AMALGAMS                         = GetModConfigData("amalgams"),
    HUNGRYFROGS                      = GetModConfigData("hungryfrogs"),
    COWARDFROGS                      = GetModConfigData("cowardfrogs"),
    INSUL_THERMALSTONE               = GetModConfigData("insul_thermalstone"),
    UNCOOL_CHESTER                   = GetModConfigData("uncool_chester"),
    HOODEDFOREST                     = GetModConfigData("hoodedforest"),
    GHOSTWALRUS                      = GetModConfigData("ghostwalrus"),
    WINONA_GEN                       = GetModConfigData("winona_gen_"),
    RICE                             = GetModConfigData("rice"),
    NEWRECIPES                       = GetModConfigData("newrecipes"),
    CAVECLOPS                        = GetModConfigData("caveclops"),
    HOTCAVES                         = GetModConfigData("hotcaves"),
    ITEMCHECK                        = GetModConfigData("itemcheck"),
    SEEDS                            = GetModConfigData("seeds"),
    MAXHPHITTERS                     = GetModConfigData("maxhphitters"),
    BEEFALO_NERF                     = GetModConfigData("beefalo_nerf"),
    NO_MOCK_DRAGONFLY_BOSS_TIME      = GetModConfigData("wiltfly_spawn"),
    NO_MOTHER_GOOSE_BOSS_TIME        = GetModConfigData("mother_goose_spawn"),
    WATHOM_MAX_DAMAGE_CAP            = GetModConfigData("wathom_maxdmg"),
    WATHOM_AMPED_VULNERABILITY       = GetModConfigData("wathom_ampvulnerability"),
    WATHOM_ARMOR_DAMAGE              = GetModConfigData("wathom_armordamage"),
    PK_GUARDS                        = GetModConfigData("pigking_guards"),
    BERNIE_BUFF                      = GetModConfigData("bernie_buffs"),
    COMPROMISING_SHADOWVORTEX        = GetModConfigData("compromising_vortex"),
    DISABLE_MEGAFLARE                = GetModConfigData("disable_megaflare"),
    WIXIE                            = GetModConfigData("wixie_walter"),
    --boss hp qol
    BEEQUEEN_HEALTH                  = GetModConfigData("bee queen health"),
    TOADSTOOL_HEALTH                 = GetModConfigData("toadstool health"),
    TWIN1_HEALTH                     = GetModConfigData("twins health"),
    TWIN2_HEALTH                     = GetModConfigData("twins health"),
    ISLAND_ADVENTURES                = ia_check,
    MONSTERSMALLMEAT                 = GetModConfigData("monstersmallmeat"),
}

-- [              DST Related Overrides                  ]

if GetModConfigData("beebox_nerf") then
    TUNING.BEEBOX_BEES = 2
    TUNING.BEEBOX_RELEASE_TIME = (0.5 * day_time) / 2
end

if GetModConfigData("wixie_walter") then
    TUNING.WOBY_BIG_HUNGER = GLOBAL.TUNING.WALTER_HUNGER
    TUNING.WOBY_BIG_HUNGER_RATE = GLOBAL.TUNING.WILSON_HUNGER_RATE / 1.65

    TUNING.WOBY_SMALL_HUNGER = GLOBAL.TUNING.WALTER_HUNGER
    TUNING.WOBY_SMALL_HUNGER_RATE = GLOBAL.TUNING.WILSON_HUNGER_RATE / 1.65

    TUNING.GAMEMODE_STARTING_ITEMS.DEFAULT.WALTER = { "walterhat", "meatrack_hat", "meat", "monstermeat" }
    TUNING.GAMEMODE_STARTING_ITEMS.DEFAULT.WIXIE = { "slingshot", "slingshotammo_rock", "slingshotammo_rock",
        "slingshotammo_rock", "slingshotammo_rock", "slingshotammo_rock", "slingshotammo_rock", "slingshotammo_rock",
        "slingshotammo_rock", "slingshotammo_rock", "slingshotammo_rock" }
end

TUNING.NONLETHAL_TEMPERATURE       = false
TUNING.NONLETHAL_HUNGER            = false
TUNING.NONLETHAL_DARKNESS          = false
TUNING.NONLETHAL_PERCENT           = 0

TUNING.WINONA_BATTERY_MIN_LOAD     = 0 --generators don't drain when not powering anything, I think.

--shield buff
TUNING.SHIELDOFTERROR_DAMAGE       = 59.5

TUNING.NO_BOSS_TIME                = 24
--TUNING.DISEASE_DELAY_TIME = total_day_time * 50 / 1.5
--TUNING.DISEASE_DELAY_TIME_VARIANCE = total_day_time * 20
TUNING.DISEASE_WARNING_TIME        = total_day_time * 5
TUNING.SANITY_BECOME_INSANE_THRESH = 40 / 200 -- 20%
TUNING.SANITY_BECOME_SANE_THRESH   = 45 / 200 -- 22.5%

TUNING.WORMWOOD_BURN_TIME          = TUNING.DSTU.WORMWOOD_BURN_TIME

if GetModConfigData("wormwood_extrafiredmg") then
    TUNING.WORMWOOD_FIRE_DAMAGE = TUNING.DSTU.WORMWOOD_FIRE_DAMAGE
end

TUNING.AFFINITY_15_CALORIES_TINY = 1.6
TUNING.AFFINITY_15_CALORIES_SMALL = 1.4
TUNING.AFFINITY_15_CALORIES_MED = 1.2
TUNING.AFFINITY_15_CALORIES_LARGE = 1.12
TUNING.AFFINITY_15_CALORIES_HUGE = 1.067
TUNING.AFFINITY_15_CALORIES_SUPERHUGE = 1.034

--TUNING.ANTLION_RAGE_TIME_INITIAL = TUNING.TOTAL_DAY_TIME * 4
--TUNING.ANTLION_RAGE_TIME_MAX = TUNING.TOTAL_DAY_TIME * 5

--TUNING.ARMORBRAMBLE_DMG = 10

if GetModConfigData("wanda_nerf") then
    TUNING.POCKETWATCH_SHADOW_DAMAGE = wilson_attack * 1.5
    TUNING.POCKETWATCH_REVIVE_COOLDOWN = TUNING.POCKETWATCH_REVIVE_COOLDOWN * 2 --doubled cooldown
end

if GetModConfigData("sleepingbuff") then
    TUNING.SLEEP_TICK_PERIOD = TUNING.SLEEP_TICK_PERIOD / GetModConfigData("sleepingbuff")
    --TUNING.SLEEP_TICK_PERIOD = TUNING.SLEEP_TICK_PERIOD / TUNING.DSTU.SLEEPINGBUFF
end

TUNING.BATTLESONG_FIRE_RESIST_MOD = 0

TUNING.SPAWNPROTECTIONBUFF_IDLE_DURATION = TUNING.SPAWNPROTECTIONBUFF_IDLE_DURATION * 4
TUNING.SPAWNPROTECTIONBUFF_DURATION = 5
TUNING.SPAWNPROTECTIONBUFF_SPAWN_DIST_SQ = 3 * 3

TUNING.MULTITOOL_DAMAGE = TUNING.AXE_DAMAGE


TUNING.HAWAIIANSHIRT_PERISHTIME = TUNING.HAWAIIANSHIRT_PERISHTIME + total_day_time * 5

--Sailing Rebalance related tuning changes
--trident buff
TUNING.TRIDENT.DAMAGE = wilson_attack * 1.5
TUNING.TRIDENT.OCEAN_DAMAGE = wilson_attack * 2.4
TUNING.TRIDENT.USES = TUNING.TRIDENT.USES + 50
TUNING.TRIDENT.SPELL.USE_COUNT = TUNING.TRIDENT.USES
TUNING.TRIDENT.SPELL.DAMAGE = wilson_attack * 1.33

--bumper buff
TUNING.BOAT.BUMPERS.KELP.HEALTH = TUNING.BOAT.BUMPERS.KELP.HEALTH * 1.33
TUNING.BOAT.BUMPERS.SHELL.HEALTH = TUNING.BOAT.BUMPERS.SHELL.HEALTH * 1.33

--cannon buff
TUNING.CANNONBALLS.ROCK.SPEED = TUNING.CANNONBALLS.ROCK.SPEED * 1.25
TUNING.CANNONBALLS.ROCK.GRAVITY = TUNING.CANNONBALLS.ROCK.GRAVITY * 1.25

TUNING.CANNONBALL_RADIUS = TUNING.CANNONBALL_RADIUS * 1.25
TUNING.CANNONBALL_SPLASH_RADIUS = TUNING.CANNONBALL_SPLASH_RADIUS * 1.33
TUNING.CANNONBALL_SPLASH_DAMAGE_PERCENT = 1

--sea weed changes
TUNING.WATERPLANT.DAMAGE = TUNING.WATERPLANT.DAMAGE * 0.75
TUNING.WATERPLANT.ITEM_DAMAGE = TUNING.WATERPLANT.ITEM_DAMAGE * 1.75

--shark nerf
TUNING.SHARK.DAMAGE = 50 / 3

--more treasures
TUNING.MESSAGEBOTTLE_NOTE_CHANCE = 0.66

--nautopilot buff
TUNING.BOAT.BOAT_MAGNET.MAX_DISTANCE = TUNING.BOAT.BOAT_MAGNET.MAX_DISTANCE * 2
TUNING.BOAT.BOAT_MAGNET.MAX_VELOCITY = TUNING.BOAT.BOAT_MAGNET.MAX_VELOCITY *
    10 --No matter the boatspeed, nautopilots should be able to keep up.
TUNING.BOAT.BOAT_MAGNET.CATCH_UP_SPEED = TUNING.BOAT.BOAT_MAGNET.CATCH_UP_SPEED * 100

--lowered CK health
--TUNING.CRABKING_HEALTH = TUNING.CRABKING_HEALTH * 0.66
--TUNING.CRABKING_HEALTH_BONUS = TUNING.CRABKING_HEALTH_BONUS * 0.66
--TUNING.CRABKING_REGEN = TUNING.CRABKING_REGEN * 0.33
--TUNING.CRABKING_REGEN_BUFF = TUNING.CRABKING_REGEN * 0.33

if GetModConfigData("wortox") == "UMNERF" then
    TUNING.WORTOX_HEALTH = 150
end

if GetModConfigData("wortox") == "APOLLO" then
    TUNING.WORTOX_SOULHEAL_MINIMUM_HEAL = 5
    TUNING.WORTOX_MAPHOP_DISTANCE_SCALER = TUNING.WORTOX_MAPHOP_DISTANCE_SCALER * 1.5 --50%
end
