--ATOBA: remind me to never do setpieces manually ever again.
  return {
    version = "1.1",
    luaversion = "5.1",
    orientation = "orthogonal",
    width = 8,
    height = 8,
    tilewidth = 64,
    tileheight = 64,
    properties = {},
    tilesets = {
        {
            name = "ground",
            firstgid = 1,
            filename = "E:/Klei/DST_Feature/tools/tiled/dont_starve/ground.tsx",
            tilewidth = 64,
            tileheight = 64,
            spacing = 0,
            margin = 0,
            image = "E:/Klei/DST_Feature/tools/tiled/dont_starve/tiles.png",
            imagewidth = 512,
            imageheight = 384,
            properties = {},
            tiles = {}
        }
    },
    layers = {
        {
            type = "tilelayer",
            name = "BG_TILES",
            x = 0,
            y = 0,
            width = 8,
            height = 8,
            visible = true,
            opacity = 1,
            properties = {},
            encoding = "lua",
            data = {
              0,  0,   0,  0,  0,  0,  34, 34,
              0,  34,  34, 0,  0,  0,  0,  34,
              0,  34,  0,  0,  0,  34, 0,  0,
              0,  0,   0,  34, 34, 34, 0,  0,
              0,  34,  34, 34, 34, 0,  0,  34,
              34, 34,  34, 34, 34, 0,  0,  34,
              0,  34,  34, 34, 34, 0,  0,  0,
              0,  34,  0,  0,  34, 34, 0,  0
            }
        },
        {
            type = "objectgroup",
            name = "FG_OBJECTS",
            visible = true,
            opacity = 1,
            properties = {},
            objects = {
                {
                    name = "moonrock",
                    type = "rock_moon",
                    shape = "rectangle",
                    x = 481,
                    y = 309,
                    width = 0,
                    height = 0,
                    visible = true,
                    properties = {}
                },
                {
                    name = "tree",
                    type = "moon_tree_tall",
                    shape = "rectangle",
                    x = 478,
                    y = 49,
                    width = 0,
                    height = 0,
                    visible = true,
                    properties = {}
                },
                {
                    name = "stonefruit",
                    type = "rock_avocado_bush",
                    shape = "rectangle",
                    x = 97,
                    y = 100,
                    width = 0,
                    height = 0,
                    visible = true,
                    properties = {}
                },
                {
                    name = "fissure0",
                    type = "moon_fissure",
                    shape = "rectangle",
                    x = 309,
                    y = 474,
                    width = 0,
                    height = 0,
                    visible = true,
                    properties = {}
                },
                {
                    name = "fissure0",
                    type = "moon_fissure",
                    shape = "rectangle",
                    x = 136,
                    y = 313,
                    width = 0,
                    height = 0,
                    visible = true,
                    properties = {}
                },
                {
                    name = "",
                    type = "",
                    shape = "rectangle",
                    x = 173,
                    y = 318,
                    width = 13,
                    height = 0,
                    visible = true,
                    properties = {}
                },
                {
                    name = "tree",
                    type = "moon_tree_tall",
                    shape = "rectangle",
                    x = 115,
                    y = 405,
                    width = 0,
                    height = 0,
                    visible = true,
                    properties = {}
                },
                {
                    name = "tree",
                    type = "moon_tree_tall",
                    shape = "rectangle",
                    x = 294,
                    y = 405,
                    width = 0,
                    height = 0,
                    visible = true,
                    properties = {}
                },
                {
                    name = "tree",
                    type = "moon_tree_tall",
                    shape = "rectangle",
                    x = 348,
                    y = 161,
                    width = 0,
                    height = 0,
                    visible = true,
                    properties = {}
                },
                {
                    name = "tree",
                    type = "moon_tree_tall",
                    shape = "rectangle",
                    x = 250,
                    y = 281,
                    width = 0,
                    height = 0,
                    visible = true,
                    properties = {}
                },
                {
                    name = "glass",
                    type = "moonglass_rock",
                    shape = "rectangle",
                    x = 185,
                    y = 368,
                    width = 0,
                    height = 0,
                    visible = true,
                    properties = {}
                },
                {
                    name = "glass",
                    type = "moonglass_rock",
                    shape = "rectangle",
                    x = 247,
                    y = 343,
                    width = 0,
                    height = 0,
                    visible = true,
                    properties = {}
                },
                {
                    name = "glass",
                    type = "moonglass_rock",
                    shape = "rectangle",
                    x = 87,
                    y = 352,
                    width = 0,
                    height = 0,
                    visible = true,
                    properties = {}
                },
                {
                    name = "glass",
                    type = "moonglass_rock",
                    shape = "rectangle",
                    x = 230,
                    y = 428,
                    width = 0,
                    height = 0,
                    visible = true,
                    properties = {}
                },
                {
                    name = "glass",
                    type = "moonglass_rock",
                    shape = "rectangle",
                    x = 220,
                    y = 278,
                    width = 0,
                    height = 0,
                    visible = true,
                    properties = {}
                },
                {
                    name = "glass",
                    type = "moonglass_rock",
                    shape = "rectangle",
                    x = 95,
                    y = 444,
                    width = 0,
                    height = 0,
                    visible = true,
                    properties = {}
                }
            }
        }
    }
}
