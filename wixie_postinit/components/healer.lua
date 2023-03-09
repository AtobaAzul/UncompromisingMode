local env = env
GLOBAL.setfenv(1, GLOBAL)
------------------------Fire spread is less efficient in winter-----------------------------------------
env.AddComponentPostInit("healer", function(self)
	local _OldHeal = self.Heal
	
	function self:Heal(target)
		if self.health
			and (self.inst.components.inventoryitem ~= nil 
			and self.inst.components.inventoryitem.owner
			and self.inst.components.inventoryitem.owner:HasTag("pinetreepioneer") 
			and target.components.health ~= nil
			or target:HasTag("pinetreepioneer")) then
			
			if self.inst.prefab == "tillweedsalve" then
				target:AddDebuff("walterbonus_buff_"..self.inst.prefab, "walterbonus_buff", {duration = 32})
			elseif self.inst.prefab == "brine_balm" then
				target:AddDebuff("walterbonus_buff_"..self.inst.prefab, "walterbonus_buff", {duration = 35})
			else
				target:AddDebuff("walterbonus_buff_"..self.inst.prefab, "walterbonus_buff", {duration = self.health / 2})
			end
		end
		
		return _OldHeal(self, target)
	end
end)