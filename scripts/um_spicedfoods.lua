local spicedfoods = {}
local um_preparedfoods = require("um_preparedfoods")

GenerateSpicedFoods(um_preparedfoods)

local spices = require("spicedfoods")

for k, data in pairs(spices) do
	for name, v in pairs(um_preparedfoods) do
		if data.basename == name then
			spicedfoods[k] = data
		end
	end
end

return spicedfoods