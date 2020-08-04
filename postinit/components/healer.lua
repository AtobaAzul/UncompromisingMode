local env = env
GLOBAL.setfenv(1, GLOBAL)
------------------------Fire spread is less efficient in winter-----------------------------------------
env.AddComponentPostInit("healer", function(self)
	local _OldHeal = self.Heal
	self.bool = false
	
	function self:Bloomer(bool)
		if bool then
			self.bool = true
		else
			self.bool = false
		end
	end
	
	function self:Heal(target)
		if self.bool then
			if not (target.components.health ~= nil and target.components.health:IsDead()) and
				not target:HasTag("playerghost") then
				target:PushEvent("forcebloom")
			end
		end
		
		if target.components.health ~= nil then
        target.components.health:DoDelta(self.health, false, self.inst.prefab)
        if self.inst.components.stackable ~= nil and self.inst.components.stackable:IsStack() then
            self.inst.components.stackable:Get():Remove()
        else
            self.inst:Remove()
        end
        return true
    end
		return _OldHeal(target)
	end
end)