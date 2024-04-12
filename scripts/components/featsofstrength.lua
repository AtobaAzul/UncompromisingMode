local FeatsOfStrength = Class(function(self, inst)
    self.inst = inst
end)

function FeatsOfStrength:MightySwing(target)

	local cost = 
		(self.inst:HasTag("mighty_strikes_5") and TUNING.FEAT_OF_STRENGTH_MIGHTY_STRIKE_5_COST) or
		(self.inst:HasTag("mighty_strikes_4") and TUNING.FEAT_OF_STRENGTH_MIGHTY_STRIKE_4_COST) or
		(self.inst:HasTag("mighty_strikes_3") and TUNING.FEAT_OF_STRENGTH_MIGHTY_STRIKE_3_COST) or
		(self.inst:HasTag("mighty_strikes_2") and TUNING.FEAT_OF_STRENGTH_MIGHTY_STRIKE_2_COST) or
		(self.inst:HasTag("mighty_strikes_1") and TUNING.FEAT_OF_STRENGTH_MIGHTY_STRIKE_1_COST) or
		TUNING.FEAT_OF_STRENGTH_MIGHTY_STRIKE_BASE_COST
	local mightiness = self.inst.components.mightiness and self.inst.components.mightiness:GetCurrent()
	local hunger = self.inst.components.hunger:GetPercent() * TUNING.WOLFGANG_HUNGER
	
	if target and self.inst.components.mightiness and (self.inst.components.mightiness:GetCurrent() > cost or 
		self.inst:HasTag("mighty_hunger") and self.inst:HasTag("mightiness_mighty") and hunger >= (mightiness - cost)/TUNING.LUNAR_MIGHTY_HUNGER_TO_MIGHTINESS_RATIO) then 
		local weapon = self.inst.components.combat:GetWeapon()
		local doubledplanar = false
		if weapon ~= nil and weapon.components.planardamage ~= nil then
			weapon.components.planardamage:AddMultiplier(self.inst, 4, "mighty_strikes")
			doubledplanar = true
		end
		if target.components.health ~= nil then
			self.inst.components.combat:DoAttack(target, nil, nil, nil, 2)
			if self.inst:HasTag("shadow_strikes") then
				self.inst:IncreaseCombo(1)
			end
			if doubledplanar then
				weapon.components.planardamage:RemoveMultiplier(self.inst, "mighty_strikes")
			end
			if self.inst.player_classified ~= nil then
				self.inst.player_classified.playworkcritsound:push()
			end
			self.inst.components.mightiness:DoDelta(-cost)
			if mightiness < cost then 
				self.inst.components.hunger:DoDelta((mightiness - cost)/TUNING.LUNAR_MIGHTY_HUNGER_TO_MIGHTINESS_RATIO)
			end
			
			self.inst:AddTag("mighty_strike_cooldown")
			self.inst:DoTaskInTime(TUNING.FEAT_OF_STRENGTH_MIGHTY_STRIKE_COOLDOWN, function(inst) inst:RemoveTag("mighty_strike_cooldown") end)
		end
	else
		self.inst.components.talker:Say(GetString(self.inst, "NEED_MORE_MIGHTINESS"))
		self.inst.components.combat:DoAttack(target)
	end
end

return FeatsOfStrength