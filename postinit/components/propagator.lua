local env = env
GLOBAL.setfenv(1, GLOBAL)
------------------------Fire spread is less efficient in winter-----------------------------------------
env.AddComponentPostInit("propagator", function(self)
	local _OldOnUpdate = self.OnUpdate
	
	function self:OnUpdate(dt)
		if TheWorld.state.season == "winter" then
			self.currentheat = math.max(0, self.currentheat - dt * self.decayrate )

			local x, y, z = self.inst.Transform:GetWorldPosition()
			
			if self.spreading then
				local prop_range = (self.propagaterange or 3) * TUNING.DSTU.WINTER_FIRE_MOD or 0
				local ents = TheSim:FindEntities(x, y, z, prop_range, nil, { "INLIMBO" })
				if ents ~= nil and #ents > 0 then
					local dmg_range = self.damagerange * TUNING.DSTU.WINTER_FIRE_MOD
					local dmg_range_sq = dmg_range * dmg_range
					local prop_range_sq = prop_range * prop_range
					local isendothermic = self.inst.components.heater ~= nil and self.inst.components.heater:IsEndothermic()

					for i, v in ipairs(ents) do
						if v:IsValid() then
							local dsq = distsq(pos, v:GetPosition())

							if v ~= self.inst then
								if v.components.propagator ~= nil and
									v.components.propagator.acceptsheat and
									not v.components.propagator.pauseheating then
									local percent_heat = math.max(.1, 1 - dsq / prop_range_sq)
									v.components.propagator:AddHeat(self.heatoutput * percent_heat * dt)
								end

								if v.components.freezable ~= nil then
									v.components.freezable:AddColdness(-.25 * self.heatoutput * dt * TUNING.DSTU.WINTER_FIRE_MOD)
									if v.components.freezable:IsFrozen() and v.components.freezable.coldness <= 0 then
										v.components.freezable:Unfreeze()
									end
								end

								if not isendothermic and (v:HasTag("frozen") or v:HasTag("meltable")) then
									v:PushEvent("firemelt")
									v:AddTag("firemelt")
								end
							end

							if self.damages and
								v.components.propagator ~= nil and
								-----------------------------------------------
								dsq < dmg_range_sq and
								v.components.health ~= nil and

								v.components.health.vulnerabletoheatdamage ~= false then
								local percent_damage = self.source ~= nil and self.source:HasTag("player") and self.pvp_damagemod or 1
								v.components.health:DoFireDamage(self.heatoutput * percent_damage * dt)
							end
						end
					end
				end
			else
				if not (self.inst.components.heater ~= nil and self.inst.components.heater:IsEndothermic()) then
					local prop_range = (self.propagaterange or 3) * TUNING.DSTU.WINTER_FIRE_MOD or 0
					local ents = TheSim:FindEntities(x, y, z, prop_range, { "frozen", "firemelt" })
					for i, v in ipairs(ents) do
						v:PushEvent("stopfiremelt")
						v:RemoveTag("firemelt")
					end
				end
				if self.currentheat <= 0 then
					self:StopUpdating()
				end
			end
		else
			return _OldOnUpdate(self, dt) --Hornet: wait, should I do a return or just call it without the return?
		end
	end
end)