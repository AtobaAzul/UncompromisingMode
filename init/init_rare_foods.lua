------------------------------------------------------------------------------------
-- Rarer foods - Decreases in frequency and yield of various food sources
------------------------------------------------------------------------------------
local seg_time = 30

local day_segs = 10
local dusk_segs = 4
local night_segs = 2

local day_time = seg_time * day_segs
local total_day_time = seg_time * 16

local day_time = seg_time * day_segs
local dusk_time = seg_time * dusk_segs
local night_time = seg_time * night_segs

-----------------------------------------------------------------
-- stone fruits increased duration
-----------------------------------------------------------------
GLOBAL.TUNING.ROCK_FRUIT_REGROW =
{
    EMPTY = { BASE = 2*day_time*GLOBAL.TUNING.DSTU.STONE_FRUIT_GROWTH_INCREASE, VAR = 2*seg_time },
    PREPICK = { BASE = seg_time*GLOBAL.TUNING.DSTU.STONE_FRUIT_GROWTH_INCREASE, VAR = 0 },
    PICK = { BASE = 3*day_time*GLOBAL.TUNING.DSTU.STONE_FRUIT_GROWTH_INCREASE, VAR = 2*seg_time },
    CRUMBLE = { BASE = day_time*GLOBAL.TUNING.DSTU.STONE_FRUIT_GROWTH_INCREASE, VAR = 2*seg_time }
}

-----------------------------------------------------------------
-- No grow in winter
-----------------------------------------------------------------
-- Relevant: MakeNoGrowInWinter in standardcomponents.lua

-- Stone fruits bushs
AddPrefabPostInit("rock_avocado_bush", function(inst)
    if inst~= nil and inst.components.pickable ~= nil then
        GLOBAL.MakeNoGrowInWinter(inst)
    end
end)

-- Cactus
AddPrefabPostInit("cactus", function(inst)
    if inst~= nil and inst.components.pickable ~= nil then
        GLOBAL.MakeNoGrowInWinter(inst)
    end
end)

-- Oasis Cactus
AddPrefabPostInit("oasis_cactus", function(inst)
    if inst~= nil and inst.components.pickable ~= nil then
        GLOBAL.MakeNoGrowInWinter(inst)
    end
end)

-- Spiky twigs
AddPrefabPostInit("marsh_bush", function(inst)
    if inst~= nil and inst.components.pickable ~= nil then
        GLOBAL.MakeNoGrowInWinter(inst)
    end
end)

-----------------------------------------------------------------
-- Carrots are rare
-----------------------------------------------------------------
--TODO: Change regrowthmanager.lua as well

-----------------------------------------------------------------
-- TODO: berry bushs are rare
-----------------------------------------------------------------

-----------------------------------------------------------------
-- TODO: goose setpieces fewer foods WIP
-----------------------------------------------------------------
-- Relevant: AddRoomPreInit, MooseBreedingTask, MooseGooseBreedingGrounds, moose_nesting_ground, carrot_planted, berrybush, berrybush_juicy
-- Command: c_gonext("moose_nesting_ground")
--[[ require ("map/room_functions")

AddRoom("MooseGooseBreedingGrounds", {
	colour={r=0.2,g=0.0,b=0.2,a=0.3},
	value = GROUND.GRASS,
	tags = {"ForceConnected", "RoadPoison"},
	contents =  
	{
        countprefabs= 
        {
			moose_nesting_ground = 4,
        },
        distributepercent = 0.275,
        distributeprefabs =
        {
        	berrybush = 0.1,
        	berrybush_juicy = 0.1,
        	carrot_planted = 0.1,
			flower = 0.333,
			grass = 0.8,
			flint = 0.1,
			sapling = 0.8,
			twiggytree = .32,
            evergreen = 1,
			pond = 0.01,
        },
    }
}) ]]--

-----------------------------------------------------------------
-- TODO:carrots sometimes are other veggies
-----------------------------------------------------------------