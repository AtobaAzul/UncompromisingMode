local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
--[[local function SecondDeerAttack(brain)
    second_attack = WhileNode(function()
							return self.inst.secondattack and
								not self.inst.sg:HasStateTag("casting")
								
									end, "Second Attack", function(self.inst) self.inst.sg:GoToState("second_attack") end,
							end
    table.insert(brain.bt.root.children, 3, second_attack)
end

env.AddBrainPostInit("deergemmedbrain", SecondDeerAttack)]]