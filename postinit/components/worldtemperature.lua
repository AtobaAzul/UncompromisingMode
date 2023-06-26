local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
local UpvalueHacker = require("tools/upvaluehacker")
env.AddComponentPostInit("worldtemperature", function(self)
    local _CalculateTemperature = UpvalueHacker.GetUpvalue(self.GetDebugString, "CalculateTemperature") -- This is an old copy of the function, right? This would cause a stackoverflow when it gets set again, right???

    local function new_CalculateTemperature()
        return _CalculateTemperature() * (TheWorld:HasTag("heatwavestart") and 1.5 or 1) -- Is 2 too much?
    end

    UpvalueHacker.SetUpvalue(self.GetDebugString, new_CalculateTemperature, "CalculateTemperature")
end)
