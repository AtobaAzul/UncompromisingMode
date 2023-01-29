--a simple template static layout wihout anything for umss
--this is for when countprefabs is not ideal.

return {
    version = "1.1",
    luaversion = "5.1",
    orientation = "orthogonal",
    width = 8,
    height = 8,
    tilewidth = 16,
    tileheight = 16,
    properties = {},
    tilesets = {
      {
        name = "ground",
        firstgid = 1,
        filename = "../../../../tools/tiled/dont_starve/ground.tsx",
        tilewidth = 64,
        tileheight = 64,
        spacing = 0,
        margin = 0,
        image = "../../../../tools/tiled/dont_starve/tiles.png",
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
          0, 0, 0, 0, 0, 0, 0, 0,
          0, 0, 0, 0, 0, 0, 0, 0,
          0, 0, 0, 0, 0, 0, 0, 0,
          0, 0, 0, 0, 0, 0, 0, 0,
          0, 0, 0, 0, 0, 0, 0, 0,
          0, 0, 0, 0, 0, 0, 0, 0,
          0, 0, 0, 0, 0, 0, 0, 0,
          0, 0, 0, 0, 0, 0, 0, 0
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
            name = "",
            type = "ums_biometable",--REPLACE THIS.
            shape = "rectangle",
            x = 63,
            y = 64,
            width = 0,
            height = 0,
            visible = true,
            properties = {}
          },
        }
      }
    }
  }
  