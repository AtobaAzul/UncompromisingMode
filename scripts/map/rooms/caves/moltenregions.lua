require "map/room_functions"

local Layouts = require ("map/layouts").Layouts
local StaticLayout = require ("map/static_layout")

---------------------------------------------
-- Bat Caves
---------------------------------------------

-- Classic bat cave
AddRoom("MoltenBatCave", {
    colour={r=0.3,g=0.2,b=0.1,a=0.3},
    value = WORLD_TILES.MAGMA_ASH,
    tags = {"Hutch_Fishbowl"},
    type = NODE_TYPE.Room,
    contents =  {
        distributepercent = .15,
        distributeprefabs=
        {
            batcave = 0.05,
            guano = 0.27,
            goldnugget=.05,
            flint=0.05,
            stalagmite_tall=0.4,
            stalagmite_tall_med=0.4,
            stalagmite_tall_low=0.4,
            pillar_cave_rock = 0.08,
            fissure = 0.05,
			um_rockmaterial1 = 0.3,
			um_rockmaterial2 = 0.1,
			umss_general = 0.6,
        },
		prefabdata = {
			umss_general = function() return {table = "MAGMASPLOTCH"..math.random(1,4)} end,
		},
    }
})

-- Very batty bat cave
AddRoom("MoltenBattyCave", {
    colour={r=0.3,g=0.2,b=0.1,a=0.3},
    value = WORLD_TILES.MAGMA_ASH,
    tags = {"Hutch_Fishbowl"},
    type = NODE_TYPE.Room,
    contents =  {
        distributepercent = .25,
        distributeprefabs=
        {
            batcave = 0.15,
            guano = 0.27,
            goldnugget=.05,
            flint=0.05,
            stalagmite_tall=0.4,
            stalagmite_tall_med=0.4,
            stalagmite_tall_low=0.4,
            pillar_cave_rock = 0.08,
            fissure = 0.05,
			um_rockmaterial1 = 0.3,
			um_rockmaterial2 = 0.1,
			umss_general = 0.6,
        },
		prefabdata = {
			umss_general = function() return {table = "MAGMASPLOTCH"..math.random(1,4)} end
		},
    }
})
-- Ferny bat cave
AddRoom("MoltenFernyBatCave", {
    colour={r=0.3,g=0.2,b=0.1,a=0.3},
    value = WORLD_TILES.MAGMA_ASH,
    tags = {"Hutch_Fishbowl"},
    type = NODE_TYPE.Room,
    contents =  {
        distributepercent = .25,
        distributeprefabs=
        {
            cave_fern = 0.5,
            batcave = 0.05,
            guano = 0.27,
            goldnugget=.05,
            flint=0.05,
            stalagmite_tall=0.1,
            stalagmite_tall_med=0.1,
            stalagmite_tall_low=0.1,
            pillar_cave_rock = 0.08,
            fissure = 0.05,
			um_rockmaterial1 = 0.3,
			um_rockmaterial2 = 0.1,
			umss_general = 0.3,
        },
		prefabdata = {
			umss_general = function() return {table = "MAGMASPLOTCH"..math.random(1,4)} end
		},
    }
})

local bgbatcave = {
    colour={r=0.3,g=0.2,b=0.1,a=0.3},
    value = WORLD_TILES.MAGMA_ASH,
    tags = {"Hutch_Fishbowl"},
    contents =  {
        distributepercent = .13,
        distributeprefabs=
        {
            batcave = 0.05,
            stalagmite_tall=0.4,
            stalagmite_tall_med=0.4,
            stalagmite_tall_low=0.4,
            pillar_cave_rock = 0.01,
            fissure = 0.05,
			umss_general = 0.6,
			um_rockmaterial1 = 0.3,
			um_rockmaterial2 = 0.1,
        },
		prefabdata = {
			umss_general = function() return {table = "MAGMASPLOTCH"..math.random(1,4)} end
		},
    }
}
AddRoom("BGMoltenBatCave", bgbatcave)
AddRoom("BGMoltenBatCaveRoom", Roomify(bgbatcave))

