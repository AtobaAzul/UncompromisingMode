local env = env
GLOBAL.setfenv(1, GLOBAL)
local easing = require("easing")
------------------------Fire spread is less efficient in winter-----------------------------------------
env.AddComponentPostInit("wildfires", function(self)

	local _Old = self.LightFireForPlayer
	
	function self:LightFireForPlayer(player, rescheduleFn)
	if 	not	(player.components.areaaware ~= nil and player.components.areaaware:CurrentlyInTag("hoodedcanopy")) then
		_Old(player, rescheduleFn)
		else
	    rescheduleFn(player)
	end
end
end)