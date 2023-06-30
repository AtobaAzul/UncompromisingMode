local env = env
GLOBAL.setfenv(1, GLOBAL)
local UpvalueHacker = require("tools/upvaluehacker")

env.AddComponentPostInit("worldwind", function(self)
    local MIN_TIME_TO_WIND_CHANGE = 480
    local MAX_TIME_TO_WIND_CHANGE = 480 * 2

    UpvalueHacker.SetUpvalue(self.OnUpdate, MIN_TIME_TO_WIND_CHANGE, "MIN_TIME_TO_WIND_CHANGE")
    UpvalueHacker.SetUpvalue(self.OnUpdate, MAX_TIME_TO_WIND_CHANGE, "MAX_TIME_TO_WIND_CHANGE")
end)
