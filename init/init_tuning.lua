
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

TUNING.DSTU = 
{
    --Limits to fillers
    CROCKPOT_RECIPE_TWIG_LIMIT = 2,
    CROCKPOT_RECIPE_ICE_LIMIT = 2,
    CROCKPOT_RECIPE_ICE_PLUS_TWIG_LIMIT = 2,

    --Cooking recipe changes
    RECIPE_CHANGE_STEW_COOKTIME = 120, --in seconds
    RECIPE_CHANGE_PEROGI_PERISH = TUNING.PERISH_MED, --in days (from 20 to 10)
    RECIPE_CHANGE_MEATBALL_HUNGER = TUNING.CALORIES_SMALL*4, -- (12.5 * 4) = 50, from 62.5
    RECIPE_CHANGE_BUTTERFLY_WING_HEALTH = TUNING.HEALING_MEDSMALL - TUNING.HEALING_SMALL, -- (8 - 3) = 5;

    --Recipe changes
    RECIPE_MOONROCK_IDOL_MOONSTONE_COST = 5,
    RECIPE_CELESTIAL_UPGRADE_GLASS_COST = 20,

    --Mob changes
    MONSTER_BAT_CAVE_NR_INCREASE = 3,

    --Tripover while wet
    TRIPOVER_HEALTH_PENALTY = 15,
    TRIPOVER_ONMAXWET_CHANCE = 0.10,
    TRIPOVER_KNOCKABCK_RADIUS = 20,

    --Weapon slip increase
    SLIPCHANCE_INCREASE_X = 3,

    --Character changes
    GOOSE_WATER_WETNESS_RATE = 2,

    --Growth time increase for stone fruits
    STONE_FRUIT_GROWTH_INCREASE = 3,
}

-- [              DST Related Overrides                  ]
