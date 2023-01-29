local env = env
GLOBAL.setfenv(1, GLOBAL)

env.AddComponentPostInit("workable", function(self)
	local _OldDestroy = self.Destroy
	
	function self:Destroy(destroyer)
		if self.inst:HasTag("giant_tree") then
			return
		else
			return _OldDestroy(self, destroyer)
		end
    end

end)