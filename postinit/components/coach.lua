local env = env
GLOBAL.setfenv(1, GLOBAL)

local UpvalueHacker = require("tools/upvaluehacker")

env.AddComponentPostInit("coach", function(self)
    if not TheWorld.ismastersim then return end

    UpvalueHacker.SetUpvalue(self.StartInspiring, 0, "inspire", "SANITY_BUFF")
end)
