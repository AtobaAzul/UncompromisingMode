local env = env
GLOBAL.setfenv(1, GLOBAL)

env.AddComponentPostInit("perishable", function(self)
    local _SetPerishTime = self.SetPerishTime
	function self:SetPerishTime(time)
		if self.inst.components.edible then
			time = time / TUNING.DSTU.PERISHABLETIME
        end
		
        return _SetPerishTime(self, time)
    end
end)