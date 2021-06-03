local env = env
GLOBAL.setfenv(1, GLOBAL)
			
			
			
local function NoFirePanic(self)				
    table.remove(self.bt.root.children, 2)
end
			
env.AddBrainPostInit("spiderqueenbrain", NoFirePanic)
env.AddBrainPostInit("bishopbrain", NoFirePanic)
env.AddBrainPostInit("rookbrain", NoFirePanic)
env.AddBrainPostInit("knightbrain", NoFirePanic)
