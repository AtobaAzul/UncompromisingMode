local env = env
GLOBAL.setfenv(1, GLOBAL)

env.AddComponentPostInit("perishable", function(self)
    local _SetPerishTime = self.SetPerishTime
	function self:SetPerishTime(time)
		if (self.inst.components.edible or self.inst:AddComponent("cookable")) and not self.inst.components.equippable and not self.inst:HasTag("lightbattery") then
			time = time / TUNING.DSTU.PERISHABLETIME
        end
		
        return _SetPerishTime(self, time)
    end
end)