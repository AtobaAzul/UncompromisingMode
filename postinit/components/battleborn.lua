local env = env
GLOBAL.setfenv(1, GLOBAL)

--local UpvalueHacker = require("tools/upvaluehacker")


env.AddComponentPostInit("battleborn", function(self)
    if not TheWorld.ismastersim then return end

	function self:SetRepairEnabled(enabled)
		self.repair_enabled = enabled
	end

	self.repair_enabled = true
	self.repair_battleborn = 0
	self.repair_clamp_min = 0.33
	self.repair_clamp_max = 2.0

	function self:OnAttack(data)

		local victim = data.target
	
		if not self.inst.components.health:IsDead() and (self.validvictimfn == nil or self.validvictimfn(victim)) then
			local total_health = victim.components.health:GetMaxWithPenalty()
			local damage = (data.weapon ~= nil and data.weapon.components.weapon:GetDamage(self.inst, victim))
						or self.inst.components.combat.defaultdamage
			if damage > 0 or self.allow_zero then
				local percent = (damage <= 0 and 0)
							or (total_health <= 0 and math.huge)
							or damage / total_health
	
				--math and clamp does account for 0 and infinite cases
				local delta = math.clamp(victim.components.combat.defaultdamage * self.battleborn_bonus * percent, self.clamp_min, self.clamp_max)

				local repairDelta = math.clamp(victim.components.combat.defaultdamage * percent, self.repair_clamp_min, self.repair_clamp_max)

				--decay stored battleborn
				if self.battleborn > 0 then
					local dt = GetTime() - self.battleborn_time - self.battleborn_store_time
					if dt >= self.battleborn_decay_time then
						self.battleborn = 0
						self.repair_battleborn = 0
					elseif dt > 0 then
						local k = dt / self.battleborn_decay_time
						self.battleborn = Lerp(self.battleborn, 0, k * k)
						self.repair_battleborn = Lerp(self.repair_battleborn, 0, k * k)
					end
				end

				--store new battleborn
				self.battleborn = self.battleborn + delta
				self.repair_battleborn = self.repair_battleborn + repairDelta
				self.battleborn_time = GetTime()

				--consume battleborn if enough has been stored
				if self.battleborn > self.battleborn_trigger_threshold then
					if self.health_enabled then
						if self.inst.components.health:IsHurt() then
							self.inst.components.health:DoDelta(self.battleborn, false, "battleborn")
						end
					end

					if self.sanity_enabled then
						self.inst.components.sanity:DoDelta(self.battleborn)
					end

					if self.ontriggerfn ~= nil then
						self.ontriggerfn(self.inst, self.battleborn)
					end

					self.battleborn = 0
				end

				--consume repair battleborn if enough has been stored
				if self.repair_battleborn > self.battleborn_trigger_threshold then

					if self.repair_enabled then
						if self.inst.components.inventory ~= nil then
							self.inst.components.inventory:ForEachEquipment(self.RepairEquipment, self.repair_battleborn)
						end
					end

					self.repair_battleborn = 0
				end
			end
		end
	end

	
	function self:OnDeath()
		self.battleborn = 0
		self.repair_battleborn = 0
	end
	
end)
