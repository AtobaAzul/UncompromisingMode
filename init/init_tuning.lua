
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

    --Tripover while wet
    TRIPOVER_HEALTH_PENALTY = 15,
    TRIPOVER_ONMAXWET_CHANCE = 0.10,
    TRIPOVER_KNOCKABCK_RADIUS = 20,

    --Weapon slip increase
    SLIPCHANCE_INCREASE_X = 3,

    --Growth time increase for stone fruits
    STONE_FRUIT_GROWTH_INCREASE = 3,
}

-- [              DST Related Overrides                  ]
