local env = env
GLOBAL.setfenv(1, GLOBAL)
require "behaviours/attackwall"

-----------------------------------------------------------------
local function WallStuck(self)

    local avoidthenoid = AttackWall(self.inst)
    table.insert(self.bt.root.children, 1, avoidthenoid)
end

env.AddBrainPostInit("deerbrain", WallStuck)