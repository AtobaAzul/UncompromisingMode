require "map/room_functions"

----
--Ratacombss
----
AddRoom("RattyStairs", {
					colour={r=0,g=.9,b=0,a=.50},
					value = GROUND.FOREST,
					type = NODE_TYPE.Room,
					contents =  {
					                distributepercent = .3,
					                distributeprefabs=
					                {
                                        fireflies = 0.1,
					                    molehill=.7,
					                    grass = .05,
					                    sapling=.5,
					                    twiggytree=0.2,
					                    rocks=.03,
					                    flint=.03,
					                    berrybush=.02,
					                    berrybush_juicy = 0.01,
					                    mushtree_medium = 0.3,
					                    mushtree_tall = 0.3,
					                    mushtree_small = 0.3,
										cavelight = 0.5,
										cavelight_small = 0.5,
										cavelight_tiny = 0.5,
										flower_cave = 0.1,
										flower_cave_double = 0.05,
										flower_cave_triple = 0.05,	
					                },
							countprefabs = {
										cave_exit_ratacombs = 1,
    									},									
					            }

})

AddRoom("RattySinkhole", {
					colour={r=0,g=.9,b=0,a=.50},
					value = GROUND.FOREST,
					tags = {"RoadPoison"},
					contents =  {
					                distributepercent = .3,
					                distributeprefabs=
					                {
                                        fireflies = 0.1,
					                    evergreen_sparse=.7,
					                    grass = .05,
					                    sapling=.5,
					                    twiggytree=0.2,
					                    rocks=.03,
					                    flint=.03,
					                    berrybush=.02,
					                    berrybush_juicy = 0.01,
					                    red_mushroom = 0.3,
					                    blue_mushroom = 0.3,
					                    green_mushroom = 0.3,
										
					                },
					countprefabs = {
										cave_entrance_ratacombs = 1,
    								},
					            }

})


-- Rocky Plains
AddRoom("RattyWilds", {
    colour={r=0.7,g=0.7,b=0.7,a=0.9},
    value = GROUND.CAVE_NOISE,
    tags = {"Hutch_Fishbowl"},
    type = NODE_TYPE.Room,
    contents =  {
        distributepercent = .10,
        distributeprefabs=
        {
            rock_flintless = 1.0,
            rock_flintless_med = 1.0,
            rock_flintless_low = 1.0,
            pillar_cave_flintless = 0.2,

            uncompromising_ratherd = 1,
            goldnugget=.05,
            rocks=.1,
            flint=0.05,
        },
    }
})

-- Rocky Plains
AddRoom("RattyLink", {
    colour={r=0.7,g=0.7,b=0.7,a=0.9},
    value = GROUND.FOREST,
    tags = {"Hutch_Fishbowl"},
    contents =  {
        distributepercent = .10,
        distributeprefabs=
        {
            rock_flintless = 1.0,
            rock_flintless_med = 1.0,
            rock_flintless_low = 1.0,
            pillar_cave_flintless = 0.2,

            uncompromising_ratherd = 1,
            goldnugget=.05,
            rocks=.1,
            flint=0.05,
        },
    }
})
local bgratty = {
    colour={r=0.7,g=0.7,b=0.7,a=0.9},
    value = GROUND.FOREST,
    type = NODE_TYPE.Room,
    contents =  {
        distributepercent = .10,
        distributeprefabs=
        {
            rock_flintless = 1.0,
            rock_flintless_med = 1.0,
            rock_flintless_low = 1.0,
            pillar_cave_flintless = 0.2,
        },
    }
}

AddRoom("BGRattyCave", bgratty)
AddRoom("BGRattyCaveRoom", Roomify(bgratty))