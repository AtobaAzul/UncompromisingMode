return {
  version = "1.1",
  luaversion = "5.1",
  orientation = "orthogonal",
  width = 16,
  height = 16,
  tilewidth = 16,
  tileheight = 16,
  properties = {},
  tilesets = {
    {
      name = "tiles",
      firstgid = 1,
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
      width = 16,
      height = 16,
      visible = true,
      opacity = 1,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        11, 0, 0, 0, 11, 0, 0, 0, 6, 0, 0, 0, 11, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        11, 0, 0, 0, 6, 0, 0, 0, 6, 0, 0, 0, 6, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        6, 0, 0, 0, 6, 0, 0, 0, 6, 0, 0, 0, 11, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        11, 0, 0, 0, 6, 0, 0, 0, 11, 0, 0, 0, 11, 0, 0, 0
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
          type = "cave_entrance_lush",
          shape = "rectangle",
          x = 125,
          y = 125,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "moonrock_pillarsmall",
          shape = "rectangle",
          x = 260,
          y = 230,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "moonrock_pillarsmall",
          shape = "rectangle",
          x = 0,
          y = 20,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "moonrock_pillarsmall",
          shape = "rectangle",
          x = 250,
          y = 40,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "moonrock_pillarsmall",
          shape = "rectangle",
          x = 20,
          y = 210,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
		
		
        {
          name = "",
          type = "moonrock_pieces",
          shape = "rectangle",
          x = 50,
          y = 100,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "moonrock_pieces",
          shape = "rectangle",
          x = 70,
          y = 120,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "moonrock_pieces",
          shape = "rectangle",
          x = 180,
          y = 210,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "moonrock_pieces",
          shape = "rectangle",
          x = 210,
          y = 120,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "moonrock_pieces",
          shape = "rectangle",
          x = 50,
          y = 200,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
		
		
		
        {
          name = "",
          type = "sapling",
          shape = "rectangle",
          x = 0,
          y = 225,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "sapling",
          shape = "rectangle",
          x = 250,
          y = 50,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "sapling",
          shape = "rectangle",
          x = 300,
          y = 70,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "sapling",
          shape = "rectangle",
          x = 30,
          y = 250,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "sapling",
          shape = "rectangle",
          x = 120,
          y = 180,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
		
		
		
        {
          name = "",
          type = "evergreen_sparse",
          shape = "rectangle",
          x = 215,
          y = 140,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "evergreen_sparse",
          shape = "rectangle",
          x = 140,
          y = 232,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "evergreen_sparse",
          shape = "rectangle",
          x = 246,
          y = 130,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "evergreen_sparse",
          shape = "rectangle",
          x = 50,
          y = 80,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "evergreen_sparse",
          shape = "rectangle",
          x = 280,
          y = 220,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
		
        {
          name = "",
          type = "evergreen_sparse",
          shape = "rectangle",
          x = 215,
          y = 248,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "evergreen_sparse",
          shape = "rectangle",
          x = 170,
          y = 60,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "evergreen_sparse",
          shape = "rectangle",
          x = 100,
          y = 170,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "evergreen_sparse",
          shape = "rectangle",
          x = 210,
          y = 190,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "evergreen_sparse",
          shape = "rectangle",
          x = 226,
          y = 30,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
	

        {
          name = "",
          type = "blueberryplantbuncher",
          shape = "rectangle",
          x = 200,
          y = 140,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
	
        {
          name = "",
          type = "hooded_fern",
          shape = "rectangle",
          x = 115,
          y = 140,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "hooded_fern",
          shape = "rectangle",
          x = 160,
          y = 110,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "hooded_fern",
          shape = "rectangle",
          x = 160,
          y = 170,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "hooded_fern",
          shape = "rectangle",
          x = 210,
          y = 240,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "hooded_fern",
          shape = "rectangle",
          x = 40,
          y = 70,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "hooded_fern",
          shape = "rectangle",
          x = 60,
          y = 30,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "hooded_fern",
          shape = "rectangle",
          x = 250,
          y = 180,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "hooded_fern",
          shape = "rectangle",
          x = 270,
          y = 120,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "hooded_fern",
          shape = "rectangle",
          x = 200,
          y = 150,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "hooded_fern",
          shape = "rectangle",
          x = 190,
          y = 90,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "hooded_fern",
          shape = "rectangle",
          x = 160,
          y = 150,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "hooded_fern",
          shape = "rectangle",
          x = 130,
          y = 250,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "hooded_fern",
          shape = "rectangle",
          x = 40,
          y = 275,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "hooded_fern",
          shape = "rectangle",
          x = 260,
          y = 75,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "hooded_fern",
          shape = "rectangle",
          x = 20,
          y = 65,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "hooded_fern",
          shape = "rectangle",
          x = 190,
          y = 250,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
      }
    }
  }
}
