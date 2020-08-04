local env = env
GLOBAL.setfenv(1, GLOBAL)
------------------------Fire spread is less efficient in winter-----------------------------------------
env.AddComponentPostInit("fertilizer", function(self)
	local _OldHeal = self.Heal
	self.bool = false
	
	function self:SetBuff(bool)
		if bool then
			self.bool = true
		else
			self.bool = false
		end
	end
	
	function self:Heal(target)
		if self.bool then
			if target.components.debuffable ~= nil and target.components.debuffable:IsEnabled() and
				not (target.components.health ~= nil and target.components.health:IsDead()) and
				not target:HasTag("playerghost") then
				target.components.debuffable:AddDebuff("poopregenbuff", "poopregenbuff")
			end
		end
		
		if self.planthealth ~= nil and target.components.health ~= nil and target.components.health.canheal and target:HasTag("healonfertilize") then
        if self.inst.components.finiteuses ~= nil then
            local cost = 2
            target.components.health:DoDelta(math.min(self.planthealth, self.planthealth * self.inst.components.finiteuses:GetUses() / cost), false, self.inst.prefab)
            self.inst.components.finiteuses:Use(cost)
        else
            target.components.health:DoDelta(self.planthealth, false, self.inst.prefab)
            if self.inst.components.stackable ~= nil and self.inst.components.stackable:IsStack() then
                self.inst.components.stackable:Get():Remove()
            else
                self.inst:Remove()
            end
        end
        return true
    end
		--end
		return _OldHeal(target)
	end
end)