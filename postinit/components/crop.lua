local env = env
GLOBAL.setfenv(1, GLOBAL)
------------------------Fire spread is less efficient in winter-----------------------------------------
env.AddComponentPostInit("crop", function(self)
	local _OldFertilize = self.Fertilize
	
	function self:Fertilize(fertilizer, doer)
		if self.inst:HasTag("whisperpod") then
			return
		else
			return _OldFertilize(self, fertilizer, doer)
		end
	end
end)