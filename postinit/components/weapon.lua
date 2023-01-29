local env = env
GLOBAL.setfenv(1, GLOBAL)
local easing = require("easing")
------------------------Fire spread is less efficient in winter-----------------------------------------
env.AddComponentPostInit("weapon", function(self)
	function self:RemoveElectric()
		self.stimuli = nil
	end
	
	function self:OnAttack_NoDurabilityLoss(attacker, target, projectile)
		if self.onattack ~= nil then
			self.onattack(self.inst, attacker, target, 2)
		end

		--[[if self.inst.components.finiteuses ~= nil then
			local uses = (self.attackwear or 1) * self.attackwearmultipliers:Get()
			if attacker ~= nil and attacker:IsValid() and attacker.components.efficientuser ~= nil then
				uses = uses * (attacker.components.efficientuser:GetMultiplier(ACTIONS.ATTACK) or 1)
			end

			self.inst.components.finiteuses:Use(uses)
		end]]
	end
end)