local env = env
GLOBAL.setfenv(1, GLOBAL)

local UpvalueHacker = require("tools/upvaluehacker")

env.AddComponentPostInit("firedetector", function(self)
    local _NOTAGS  = UpvalueHacker.GetUpvalue(self.Activate, "LookForFiresAndFirestarters", "NOTAGS")
	
	if _NOTAGS ~= nil then
		table.insert(_NOTAGS, "campfire")
		table.insert(_NOTAGS, "NIGHTMARE_fueled")
	end
end)