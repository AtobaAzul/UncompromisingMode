AddRoom("ToadstoolArenaRed", {
    colour={r=1.0,g=0.0,b=0.0,a=0.9},
    value = WORLD_TILES.FUNGUSRED,
    tags = {},    
    contents = {
        countstaticlayouts = {
            ["ToadstoolArena"] = 1,
        },
        distributepercent = .3,
        distributeprefabs=
        {
            mushtree_medium = 6.0,
            red_mushroom = 0.5,
            flower_cave = 0.2,
            flower_cave_double = 0.1,
            flower_cave_triple = 0.1,

            stalagmite = 0.5,
            pillar_cave = 0.1,
            spiderhole = 0.05,

            slurper = 0.001,
        },
    }
})
AddRoom("ToadstoolArenaGreen", {
    colour={r=0.1,g=0.8,b=0.1,a=0.9},
    value = WORLD_TILES.FUNGUSGREEN,  
    contents =  {
		countstaticlayouts = {
            ["ToadstoolArena"] = 1,
        },
        distributepercent = .35,
        distributeprefabs=
        {
            mushtree_small = 6.0,
            green_mushroom = 0.5,
            flower_cave = 0.2,
            flower_cave_double = 0.1,
            flower_cave_triple = 0.1,

            rabbithouse = 0.02,

            cave_fern = 2.5,

            slurper = 0.001,
        },
    }
})
AddRoom("ToadstoolArenaBlue", {
    colour={r=0.1,g=0.1,b=0.8,a=0.9},
    value = WORLD_TILES.FUNGUS,
    contents =  {
        distributepercent = .6,
        distributeprefabs=
        {
			countstaticlayouts = {
            ["ToadstoolArena"] = 1,
			},
            mushtree_tall = 6.0,
            blue_mushroom = 0.5,
            flower_cave = 0.1,
            flower_cave_double = 0.05,
            flower_cave_triple = 0.05,

            batcave = 0.005,
            dropperweb = 0.015,

            slurper = 0.001,
        },
    }
})