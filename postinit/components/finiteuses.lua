local env = env
GLOBAL.setfenv(1, GLOBAL)

--potential support for finite uses overcharging.

env.AddComponentPostInit("finiteuses", function(self)
	local _SetUses = self.SetUses
	function self:SetUses(val)
		_SetUses(self, val)
		if self.inst:HasTag("overchargeable") then
			if self.current > self.total then
				self.inst:PushEvent("overcharged", true)
			else
				self.inst:PushEvent("overcharged", false)
			end
		end
	end
end)
