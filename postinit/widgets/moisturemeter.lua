local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
env.AddClassPostConstruct("widgets/moisturemeter", function(self)
	--[[local _OldOnUpdate = self.OnUpdate
	
	function self:OnUpdate(dt)
		_OldOnUpdate(self, dt)
		if c_countprefabs("mushroomsprout_overworld") > 0 then
			self.backing:SetTooltipColour(unpack(TUNING.DSTU.ACID_TEXT_COLOUR)) Hornet: not working, :<
		end
	end]]
end)