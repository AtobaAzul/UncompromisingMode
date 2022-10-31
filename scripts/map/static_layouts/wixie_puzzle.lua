return {
  version = "1.1",
  luaversion = "5.1",
  orientation = "orthogonal",
  width = 4,
  height = 4,
  tilewidth = 64,
  tileheight = 64,
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
      width = 4,
      height = 4,
      visible = true,
      opacity = 1,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0,
        0, 9, 9, 0,
        0, 9, 9, 0,
        0, 0, 0, 0
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
          type = "wixie_clock",
          shape = "rectangle",
          x = 55,
          y = 65,
          width = 44,
          height = 23,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "wixie_piano",
          shape = "rectangle",
          x = 180,
          y = 98,
          width = 25,
          height = 50,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "charles_t_horse",
          shape = "rectangle",
          x = 49,
          y = 168,
          width = 79,
          height = 30,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "wixie_wardrobe",
          shape = "rectangle",
          x = 108,
          y = 108,
          width = 54,
          height = 16,
          visible = true,
          properties = {}
        }
      }
    }
  }
}
