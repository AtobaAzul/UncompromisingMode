-------------------------------------------------------------------------
---------------------- Attach and dettach functions ---------------------
-------------------------------------------------------------------------
----------------------------------ATTACH---------------------------------
local function ForceToTakeMoreDamage(inst)
	local self = inst.components.combat
	local _GetAttacked = self.GetAttacked
	self.GetAttacked = function(self, attacker, damage, weapon, stimuli)
		if attacker and damage then
			-- Take extra damage
			damage = damage * 1.2
		end
		return _GetAttacked(self, attacker, damage, weapon, stimuli)
	end
end

local function ForceToTakeMoreHunger(inst)
	local self = inst.components.hunger
	local _DoDelta = self.DoDelta
	self.DoDelta = function(self, delta, overtime, ignore_invincible)
	if delta and overtime and delta < 0 then
		-- Take extra hunger
		delta = delta * 1.2
		end
		return _DoDelta(self, delta, overtime, ignore_invincible)
	end
end

local function ForceToTakeMoreTime(inst)
	local self = inst.components.oldager
	local _OnTakeDamage = self.OnTakeDamage
	self.OnTakeDamage = function(self, amount, overtime, cause, ignore_invincible, afflicter, ignore_absorb)
	if amount and overtime and amount < 0 then
		-- Take extra time
		amount = amount * 1.2
		end
		return _OnTakeDamage(self, amount, overtime, cause, ignore_invincible, afflicter, ignore_absorb)
	end
end

----------------------------------DETACH---------------------------------

local function ForceToTakeUsualDamage(inst)
	local self = inst.components.combat
	local _GetAttacked = self.GetAttacked
	self.GetAttacked = function(self, attacker, damage, weapon, stimuli)
	if attacker and damage then
			-- Take normal damage
			damage = damage / 1.2
		end
		return _GetAttacked(self, attacker, damage, weapon, stimuli)
	end
end

local function ForceToTakeUsualHunger(inst)
	local self = inst.components.hunger
	local _DoDelta = self.DoDelta
	self.DoDelta = function(self, delta, overtime, ignore_invincible)
	if delta and overtime and delta < 0 then
		-- Take normal hunger
		delta = delta / 1.2
		end
		return _DoDelta(self, delta, overtime, ignore_invincible)
	end
end

local function ForceToTakeUsualTime(inst)
	local self = inst.components.oldager
	local _OnTakeDamage = self.OnTakeDamage
	self.OnTakeDamage = function(self, amount, overtime, cause, ignore_invincible, afflicter, ignore_absorb)
	if amount and overtime and amount < 0 then
		-- Take extra time
		amount = amount / 1.2
		end
		return _OnTakeDamage(self, amount, overtime, cause, ignore_invincible, afflicter, ignore_absorb)
	end
end

--------------------------------------------------------------------------

local function oneat(inst, data)
	if inst.healthabsorption == nil then
		inst.healthabsorption = inst.components.eater.healthabsorption
	end
		
	if inst.hungerabsorption == nil then
		inst.hungerabsorption = inst.components.eater.hungerabsorption
	end
		
	if inst.sanityabsorption == nil then
		inst.sanityabsorption = inst.components.eater.sanityabsorption
	end
	
	--print(inst.healthabsorption, inst.hungerabsorption, inst.sanityabsorption)

	inst.components.eater:SetAbsorptionModifiers(0, inst.hungerabsorption or 1, 0)
		
	local strongstomach = inst.components.eater.strongstomach and data.food:HasTag("monstermeat") or (inst.components.eater.eatsrawmeat or inst:HasTag("eatsrawmeat")) and data.food:HasTag("rawmeat")

	local hasaffinity = inst.components.foodaffinity:HasPrefabAffinity(data.food)
	
	local foodmemorybuff = inst.components.foodmemory ~= nil and inst.components.foodmemory:GetFoodMultiplier(data.food.prefab) or 1
	local foodaffinitysanitybuff = inst:HasTag("playermerm") and (data.food.prefab == "kelp" or data.food.prefab == "kelp_cooked") and 0 or inst.components.foodaffinity:HasPrefabAffinity(data.food) and 15 or 0
	
	local warlybuff = inst:HasTag("warlybuffed") and 1.2 or 1

	if inst.components.eater.ignoresspoilage then
		local wxhealthvalue = data.food.components.edible.healthvalue ~= nil and data.food.components.edible.healthvalue
		local wxsanityvalue = data.food.components.edible.sanityvalue ~= nil and data.food.components.edible.sanityvalue
	
		if wxhealthvalue > 3 then
			inst.components.debuffable:AddDebuff("healthregenbuff_vetcurse_"..data.food.prefab, "healthregenbuff_vetcurse", {duration = (wxhealthvalue * 0.1)})
		else
			inst.components.health:DoDelta(wxhealthvalue)
		end
			
		if wxsanityvalue > 3 then
			inst.components.debuffable:AddDebuff("sanityregenbuff_vetcurse_"..data.food.prefab, "sanityregenbuff_vetcurse", {duration = ((wxsanityvalue + foodaffinitysanitybuff) * 0.1)})
		else
			if wxsanityvalue <= 0 then
				if not hasaffinity and not strongstomach then
					inst.components.sanity:DoDelta(wxsanityvalue)
				elseif hasaffinity then
					inst.components.debuffable:AddDebuff("sanityregenbuff_vetcurse_"..data.food.prefab, "sanityregenbuff_vetcurse", {duration = (foodaffinitysanitybuff * 0.1)})
				end
			else
				inst.components.sanity:DoDelta(wxsanityvalue)
			end
		end
	else
		local healthvalue = data.food.components.edible:GetHealth() ~= nil and (((data.food.components.edible:GetHealth() * foodmemorybuff) * warlybuff) * inst.healthabsorption)
		local sanityvalue = data.food.components.edible.sanityvalue < 0 and (((data.food.components.edible.sanityvalue * foodmemorybuff) * warlybuff) * inst.sanityabsorption) - (data.food.components.perishable ~= nil and data.food.components.perishable:IsSpoiled() and TUNING.SANITY_SMALL or 0) or data.food.components.edible:GetSanity() ~= nil and (((data.food.components.edible:GetSanity() * foodmemorybuff) * warlybuff) * inst.sanityabsorption)
		--print(sanityvalue)
		if not inst:HasTag("plantkin") then
			if healthvalue > 3 then
				inst.components.debuffable:AddDebuff("healthregenbuff_vetcurse_"..data.food.prefab, "healthregenbuff_vetcurse", {duration = (healthvalue * 0.1)})
			else
				if healthvalue < 0 then
					if not hasaffinity and not strongstomach then
						--print("damage health")
						inst.components.health:DoDelta(healthvalue)
					end
				else
					--print("health")
					inst.components.health:DoDelta(healthvalue)
				end
			end
		end
		
		if sanityvalue > 3 then
			inst.components.debuffable:AddDebuff("sanityregenbuff_vetcurse_"..data.food.prefab, "sanityregenbuff_vetcurse", {duration = ((sanityvalue + foodaffinitysanitybuff) * 0.1)})
		else
			--print("sanity below 3")
			if sanityvalue <= 0 then
				if not hasaffinity and not strongstomach then
					--print("sanity damage")
					inst.components.sanity:DoDelta(sanityvalue)
				elseif hasaffinity then
					inst.components.debuffable:AddDebuff("sanityregenbuff_vetcurse_"..data.food.prefab, "sanityregenbuff_vetcurse", {duration = (foodaffinitysanitybuff * 0.1)})
				end
			else
				inst.components.sanity:DoDelta(sanityvalue)
			end
		end
	end
end

local function ForceOvertimeFoodEffects(inst)
	if not inst:HasTag("UM_foodregen") then
	
		if inst.healthabsorption == nil then
			inst.healthabsorption = inst.components.eater.healthabsorption
		end

		if inst.hungerabsorption == nil then
			inst.hungerabsorption = inst.components.eater.hungerabsorption
		end
		
		if inst.sanityabsorption == nil then
			inst.sanityabsorption = inst.components.eater.sanityabsorption
		end

		inst.components.eater:SetAbsorptionModifiers(0, inst.hungerabsorption or 1, 0)

		inst:ListenForEvent("oneat", oneat)
	end
end

local function AttachCurse(inst, target)
    if target.components.combat ~= nil then
        --target.components.combat.externaldamagemultipliers:SetModifier(inst, .75)    Effect Removed
		target.vetcurse = true
		
		if inst:HasTag("clockmaker") then
			ForceToTakeMoreTime(target)
		else
			ForceToTakeMoreDamage(target)
		end
		
		ForceToTakeMoreHunger(target)
		ForceOvertimeFoodEffects(target)
		target:AddTag("vetcurse")
        target:ListenForEvent("respawnfromghost", function()
			target:DoTaskInTime(3, function(target) 
				if TUNING.DSTU.VETCURSE ~= "off" then
					target.components.debuffable:AddDebuff("buff_vetcurse", "buff_vetcurse")
				end
			end)
        end, target)
    end
end

local function DetachCurse(inst, target)
    if target.components.combat ~= nil then
        --target.components.combat.externaldamagemultipliers:RemoveModifier(inst)
		--target.vetcurse = false
		
		if inst:HasTag("clockmaker") then --taking a guess thats what her tag is, I swear, I actually don't know
			ForceToTakeUsualTime(target)
		else
			ForceToTakeUsualDamage(target)
		end
		
		ForceToTakeUsualHunger(target)
		target:RemoveTag("vetcurse")
    end
end

local function MakeBuff(name, onattachedfn, onextendedfn, ondetachedfn, duration, priority, prefabs)
    local function OnAttached(inst, target)
        inst.entity:SetParent(target.entity)
        inst.Transform:SetPosition(0, 0, 0) --in case of loading
        --[[inst:ListenForEvent("death", function()
            inst.components.debuff:Stop()
        end, target)]]

        --target:PushEvent("foodbuffattached", { buff = "ANNOUNCE_ATTACH_BUFF_"..string.upper(name), priority = priority })
        if onattachedfn ~= nil then
            onattachedfn(inst, target)
        end
    end


    local function OnDetached(inst, target)
        if ondetachedfn ~= nil then
            ondetachedfn(inst, target)
        end

        --target:PushEvent("foodbuffdetached", { buff = "ANNOUNCE_DETACH_BUFF_"..string.upper(name), priority = priority })
        inst:Remove()
    end

    local function fn()
        local inst = CreateEntity()

        if not TheWorld.ismastersim then
            --Not meant for client!
            inst:DoTaskInTime(0, inst.Remove)
            return inst
        end

        inst.entity:AddTransform()

        --[[Non-networked entity]]
        --inst.entity:SetCanSleep(false)
        inst.entity:Hide()
        inst.persists = false

        inst:AddTag("CLASSIFIED")

        inst:AddComponent("debuff")
        inst.components.debuff:SetAttachedFn(OnAttached)
        inst.components.debuff:SetDetachedFn(OnDetached)
        inst.components.debuff.keepondespawn = true


        return inst
    end

    return Prefab("buff_"..name, fn, nil, prefabs)
end
return MakeBuff("vetcurse", AttachCurse, nil, DetachCurse, nil, 1)