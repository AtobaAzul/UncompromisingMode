local env = env
GLOBAL.setfenv(1, GLOBAL)
require "behaviours/chaseandattack"

local function WhyAreYouRunning(self)
					
	local FightMe = ChaseAndAttack(self.inst)
					
    table.insert(self.bt.root.children, 1, FightMe)
end


env.AddBrainPostInit("moosebrain", WhyAreYouRunning)