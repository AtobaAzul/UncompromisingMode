local env = env
GLOBAL.setfenv(1, GLOBAL)
local easing = require("easing")
------------------------Fire spread is less efficient in winter-----------------------------------------
env.AddComponentPostInit("weapon", function(self)
	function self:RemoveElectric()
		self.stimuli = nil
	end
end)