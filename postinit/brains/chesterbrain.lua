local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
local MIN_FOLLOW_DIST = 0
local MAX_FOLLOW_DIST = 12
local TARGET_FOLLOW_DIST = 6
env.AddBrainPostInit("chesterbrain", function(self)
    table.insert(self.bt.root.children, 2, WhileNode( function() return self.inst.ChesterState == "LAZY" end, "CheckLazy", Follow(self.inst, function() return self.inst.components.follower.leader end, MIN_FOLLOW_DIST/2, TARGET_FOLLOW_DIST/2, MAX_FOLLOW_DIST/2)))
end)