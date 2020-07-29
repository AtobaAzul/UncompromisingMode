local env = env
GLOBAL.setfenv(1, GLOBAL)
------------------------Fire spread is less efficient in winter-----------------------------------------
env.AddComponentPostInit("explosiveresist", function(self)
	
	self.decay = nil
	
	function self:SetResistance(resistance)
		self.resistance = math.clamp(resistance, 0, 1)
		if self.resistance > 0 and not self.decay then
			self.inst:StartUpdatingComponent(self)
		else
			self.inst:StopUpdatingComponent(self)
			self.delayremaining = 0
		end
	end
	
	
	
	
end)