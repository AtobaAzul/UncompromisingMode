local env = env
GLOBAL.setfenv(1, GLOBAL)

local UpvalueHacker = require("tools/upvaluehacker")

env.AddComponentPostInit("finiteuses", function(self)
    local _NOTAGS  = UpvalueHacker.GetUpvalue(self.Activate, "LookForFiresAndFirestarters", "NOTAGS")
    table.insert(_NOTAGS, "campfire")

end)