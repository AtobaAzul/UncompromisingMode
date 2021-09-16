local function RGB(r, g, b)
    return { r / 255, g / 255, b / 255, 1 }
end


local seg_time = 30

local day_segs = 10
local dusk_segs = 4
local night_segs = 2

local day_time = seg_time * day_segs
local total_day_time = seg_time * 16

local day_time = seg_time * day_segs
local dusk_time = seg_time * dusk_segs
local night_time = seg_time * night_segs

TUNING = GLOBAL.TUNING

-- [              DSTU Related Overrides                  ]

--moved outside of tuning.dstu
if GetModConfigData("wortox") == true then
TUNING.WORTOX_HEALTH = 150
end
	
TUNING.DSTU = 
{
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
    FOOD_HONEY_PRODUCTION_PER_STAGE = {0,1,2,4},

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
    RECIPE_CHANGE_PEROGI_PERISH = TUNING.PERISH_MED, --in days (from 20 to 10)
    RECIPE_CHANGE_BACONEGG_PERISH = TUNING.PERISH_MED,
    RECIPE_CHANGE_MEATBALL_HUNGER = TUNING.CALORIES_SMALL*4, -- (12.5 * 4) = 50, from 62.5
    RECIPE_CHANGE_BUTTERMUFFIN_HEALTH = TUNING.HEALING_MED*1.5,
    
    --Limits to fillers
    CROCKPOT_RECIPE_TWIG_LIMIT = 1,
    CROCKPOT_RECIPE_ICE_LIMIT = 1,
    CROCKPOT_RECIPE_ICE_PLUS_TWIG_LIMIT = 1,

    --Monster meat meat dilution
    MONSTER_MEAT_RAW_MONSTER_VALUE = 2.5, --3
    MONSTER_MEAT_COOKED_MONSTER_VALUE = 2.0, --2.5
    MONSTER_MEAT_DRIED_MONSTER_VALUE = 1.5, --2
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
	BUTTMUFFIN = GetModConfigData("buttmuffin"),
    ----------------------------------------------------------------------------
    --Mob changes
    ----------------------------------------------------------------------------
    --Generics
    MONSTER_BAT_CAVE_NR_INCREASE = 3,
    CAVE_ENTRANCE_BATS_SPAWN_PERIOD_UM = 0.8,
    MONSTER_CATCOON_HEALTH_CHANGE = TUNING.CATCOON_LIFE * 2.5,
    
    --Mctusk
    MONSTER_MCTUSK_HEALTH_INCREASE = 3,
    MONSTER_MCTUSK_HOUND_NUMBER = 5,

    --Hounds
    MONSTER_HOUNDS_PER_WAVE_INCREASE = 1.5, --Controlled by player settings
	
	--Toadstool
	TOADSTOOL_HEALTH = GetModConfigData("toadstool health"),
	
	--Bee Queen
	BEEQUEEN_HEALTH = GetModConfigData("bee queen health"),
	
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
	VARGWAVES = GetModConfigData("vargwaves"),
	VARGWAVES_BOSS_GRACE = GetModConfigData("vargwaves grace"),
	VARGWAVES_DELAY_PERIOD = GetModConfigData("vargwaves delay"),
	
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
	
	--Ancient Trepidations
	PAWNS = GetModConfigData("pawns"),	
	
	--Spiders
	REGSPIDERJUMP = GetModConfigData("alljumperspiders"),
	SPIDERWARRIORCOUNTER = GetModConfigData("spiderwarriorcounter"),
	TRAPDOORSPIDERS = GetModConfigData("trapdoorspiders"),
	
	--Perishable Increase
	PERISHABLETIME = GetModConfigData("more perishing"),
	
	--Fire Loot Rework
	FIRELOOT = GetModConfigData("fireloot"),
	
    ----------------------------------------------------------------------------
    --Player changes
    ----------------------------------------------------------------------------
	
	
    --Tripover chance on walking with 100 wetness (depricated)
    TRIPOVER_HEALTH_DAMAGE = 10,
    TRIPOVER_ONMAXWET_CHANCE_PER_SEC = 0.10,
    TRIPOVER_KNOCKABCK_RADIUS = 2,
    TRIPOVER_ONMAXWET_COOLDOWN = 5,

    --Weapon slip increase
    SLIPCHANCE_INCREASE_X = 3,
	
	NIGHTSTICK_FUEL = 240,
	
	WET_FUEL_PENALTY = 0.20,

    ----------------------------------------------------------------------------
    --Character changes
    ----------------------------------------------------------------------------
    --Woodie
    GOOSE_WATER_WETNESS_RATE = 3,

    --Wolfgang
    WOLFGANG_SANITY_MULTIPLIER = 1.3, --prev was 1.1

    --WX78
    WX78_MOISTURE_DAMAGE_INCREASE = 3,

    --Wormwood
    WORMWOOD_BURN_TIME = 6.66, --orig 4.3
    WORMWOOD_FIRE_DAMAGE = 1.50, -- orig 1.25
	
	--Warly
    WARLY_SAME_OLD_COOLDOWN = total_day_time * 3,
	WARLY_SAME_OLD_MULTIPLIERS = { .6, .5, .35, .2, .1 },
	
	--Maxwell
	MAX_HEALTH_WELL = GetModConfigData("maxhealthwell"),
	SHADOWWAXWELL_FUEL_COST = 2,
	SHADOWWAXWELL_HEALTH_COST = 15,
	OLD_SHADOWWAXWELL_SANITY_COST = 55,
	OLD_SHADOWWAXWELL_SANITY_PENALTY = .275,
	
	--Winona
	WINONA_WORKER = GetModConfigData("winonaworker"),
	
	--Wickerbottom
	WICKERNERF = GetModConfigData("wickerbottom"),
	WICKERNERF_TENTACLES = GetModConfigData("on tentacles"),
	WICKERNERF_HORTICULTURE = GetModConfigData("applied horticulture"),
	
    --Growth time increase for stone fruits
    STONE_FRUIT_GROWTH_INCREASE = 3,
	
	--Mobs
	RAIDRAT_HEALTH = 100,
	RAIDRAT_DAMAGE = 20,
	RAIDRAT_ATTACK_PERIOD = 2,
	RAIDRAT_ATTACK_RANGE = 1,
	RAIDRAT_RUNSPEED = 8,
	RAIDRAT_WALKSPEED = 4,
	RAIDRAT_SPAWNRATE = seg_time / 5,
	RAIDRAT_SPAWNRATE_VARIANCE = (seg_time / 5) * 0.5,
	
	--Weather Start Date
    WEATHERHAZARD_START_DATE = GetModConfigData("weather start date"),
	
    RNE_CHANCE = GetModConfigData("rne chance"),

	HARDER_SHADOWS = GetModConfigData("harder_shadows"),
    MAX_DISTANCE_TO_SHADOWS = 1225, -- 35^2

    CREEPINGFEAR_SPEED = 4.8,
    CREEPINGFEAR_HEALTH = 1600,
    CREEPINGFEAR_DAMAGE = 60,
    CREEPINGFEAR_ATTACK_PERIOD = 2.3,
    CREEPINGFEAR_RANGE_1 = 3.0,
    CREEPINGFEAR_RANGE_2 = 4.0, --4.2,
    CREEPINGFEAR_SPAWN_THRESH = 0, -- 10%

    DREADEYE_SPEED = 7,
    DREADEYE_HEALTH = 350,
    DREADEYE_DAMAGE = 35,
    DREADEYE_ATTACK_PERIOD = 2,
    DREADEYE_RANGE_1 = 1,
    DREADEYE_RANGE_2 = 2,
    DREADEYE_SPAWN_THRESH = 0.20,
	
	MOCK_DRAGONFLY_DAMAGE = 125,
	
	TOADLING_DAMAGE = 50,
	TOADLING_HEALTH = 1000,
	TOADLING_ATTACK_PERIOD = 2,
	TOADLING_WALK_SPEED = 5,
	TOADLING_RUN_SPEED = 6,
	TOADLING_TARGET_DIST = 12,
	
	BAT_HEALTH = 75,
	
	TOAD_RAIN_DELAY = {min=5, max=10},
	
	SUMMER_CAVES_TEMP_MULT = 0.75,

	WINTER_CAVES_TEMP_MULT = 1.25,
	
	--SNAPDRAGON FERTILIZER VALUES
	PURPLE_VOMIT_NUTRIENTS	= { 16, 16, 0 },
	ORANGE_VOMIT_NUTRIENTS	= { 0, 16, 16 },
	YELLOW_VOMIT_NUTRIENTS	= { 16, 0, 16 },
	RED_VOMIT_NUTRIENTS		= { 0, 24, 0 },
	GREEN_VOMIT_NUTRIENTS	= { 0, 0, 24 },
	PINK_VOMIT_NUTRIENTS	= { 24, 0, 0 },
	PALE_VOMIT_NUTRIENTS	= { 8, 8, 8 }

}

TUNING.NO_BOSS_TIME = 24
--TUNING.DISEASE_DELAY_TIME = total_day_time * 50 / 1.5
--TUNING.DISEASE_DELAY_TIME_VARIANCE = total_day_time * 20
TUNING.DISEASE_WARNING_TIME = total_day_time * 5
TUNING.SANITY_BECOME_INSANE_THRESH = 40/200 -- 20%
TUNING.SANITY_BECOME_SANE_THRESH  = 45/200 -- 22.5%

TUNING.WORMWOOD_BURN_TIME = TUNING.DSTU.WORMWOOD_BURN_TIME 
TUNING.WORMWOOD_FIRE_DAMAGE = TUNING.DSTU.WORMWOOD_FIRE_DAMAGE

TUNING.AFFINITY_15_CALORIES_TINY = 1.6
TUNING.AFFINITY_15_CALORIES_SMALL = 1.4
TUNING.AFFINITY_15_CALORIES_MED = 1.2
TUNING.AFFINITY_15_CALORIES_LARGE = 1.12
TUNING.AFFINITY_15_CALORIES_HUGE = 1.067
TUNING.AFFINITY_15_CALORIES_SUPERHUGE = 1.034

--TUNING.ANTLION_RAGE_TIME_INITIAL = TUNING.TOTAL_DAY_TIME * 4
--TUNING.ANTLION_RAGE_TIME_MAX = TUNING.TOTAL_DAY_TIME * 5

TUNING.ARMORBRAMBLE_DMG = 10


TUNING.SLEEP_TICK_PERIOD = TUNING.SLEEP_TICK_PERIOD / TUNING.DSTU.SLEEPINGBUFF

-- [              DST Related Overrides                  ]
