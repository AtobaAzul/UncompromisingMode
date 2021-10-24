local env = env
GLOBAL.setfenv(1, GLOBAL)

local PLANT_DEFS = require("prefabs/farm_plant_defs").PLANT_DEFS

PLANT_DEFS.tomato.good_seasons = {spring = true,	summer = true}