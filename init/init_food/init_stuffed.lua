local env = env
GLOBAL.setfenv(1, GLOBAL)
---	This Code Applies Groginess To The Player Based On How Much Higher 
---	The Hunger Value Of Eaten Food Is Compared To The Players Max Hunger. Min 1, Max 6

env.AddPlayerPostInit(function(inst)
	--[[inst:ListenForEvent("overstuff", function(inst, data)
	local myvalue = data.oldpercent * inst.components.hunger.max
	local myvalueover = myvalue + data.delta
	
	
		if myvalueover > inst.components.hunger.max then	
		end
	end)]]







	inst:ListenForEvent("oneat", function(inst, data)
		if inst:HasTag("vetcurse") and data.food ~= nil and data.food.components.edible ~= nil and data.food.components.edible.hungervalue ~= nil then
			local overstuffed = inst.components.hunger.current + data.food.components.edible.hungervalue
			local maxhunger = inst.components.hunger.max
			local clampvalue = overstuffed - maxhunger
				
			if inst.components.grogginess ~= nil then
				if overstuffed > maxhunger then
					if inst.components.grogginess:HasGrogginess() then
						inst.components.talker:Say(GetString(inst, "ANNOUNCE_OVER_EAT", "OVERSTUFFED"))
						inst.components.grogginess:MaximizeGrogginess()
					else
						inst.components.talker:Say(GetString(inst, "ANNOUNCE_OVER_EAT", "STUFFED"))
						local delta = math.clamp(clampvalue / 10, 0.1, 2.9)
						inst.components.grogginess:AddGrogginess(delta)
					end
				end
			end
		end
	end)
end)
--[[
env.AddComponentPostInit("hunger", function(self)
	local _OldDoDelta = self.DoDelta
	
	function self:DoDelta(delta, overtime, ignore_invincible)
		if self.redirect ~= nil then
			self.redirect(self.inst, delta, overtime)
			return
		end

		if not ignore_invincible and self.inst.components.health and self.inst.components.health.invincible or self.inst.is_teleporting then
			return
		end
		
		local old = self.current
		self.current = math.clamp(self.current + delta, 0, self.max)

		self.inst:PushEvent("overstuff", { oldpercent = old / self.max, newpercent = self.current / self.max, overtime = overtime, delta2 = self.current-old, delta = delta })

		return _OldDoDelta(self, delta, overtime, ignore_invincible)
	end
end)]]