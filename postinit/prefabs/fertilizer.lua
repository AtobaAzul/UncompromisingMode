local env = env
GLOBAL.setfenv(1, GLOBAL)

local FERTILIZER_DEFS = require("prefabs/fertilizer_nutrient_defs").FERTILIZER_DEFS
local SORTED_FERTILIZERS = require("prefabs/fertilizer_nutrient_defs").SORTED_FERTILIZERS

FERTILIZER_DEFS.purple_vomit = {nutrients = {16, 16, 0}}
FERTILIZER_DEFS.orange_vomit = {nutrients = {0, 16, 16}}
FERTILIZER_DEFS.yellow_vomit = {nutrients = {16, 0, 16}}
FERTILIZER_DEFS.red_vomit = {nutrients = {0, 24, 0}}
FERTILIZER_DEFS.green_vomit = {nutrients = {0, 0, 24}}
FERTILIZER_DEFS.pink_vomit = {nutrients = {24, 0, 0}}
FERTILIZER_DEFS.pale_vomit = {nutrients = {8, 8, 8}}

for fertilizer, data in pairs(FERTILIZER_DEFS) do
	if data.inventoryimage == nil then
		if data.atlas == nil then
			data.atlas = "images/inventoryimages/"..fertilizer..".xml"
		end

		data.inventoryimage = fertilizer..".tex"
	end

	if data.name == nil then
		data.name = string.upper(fertilizer)
	end

	if data.uses == nil then
		data.uses = 1
	end
end

local sort_order =
{
	"purple_vomit",
	"orange_vomit",
	"yellow_vomit",
	"red_vomit",
	"green_vomit",
	"pink_vomit",
	"pale_vomit",
}

for i, v in ipairs(sort_order) do
	table.insert(SORTED_FERTILIZERS, v)
end
