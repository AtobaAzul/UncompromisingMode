local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
env.AddComponentPostInit("beargerspawner", function(self)
	function self:GetWarning()
		return _warning
	end
end)