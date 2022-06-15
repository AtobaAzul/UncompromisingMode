local env = env
GLOBAL.setfenv(1, GLOBAL)

local function oneat(inst, data)
	if not inst:HasTag("vetcurse") then
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
end

env.AddPlayerPostInit(function(inst)
	inst:AddTag("UM_foodregen")
	
	if not TheWorld.ismastersim then
		return
	end

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
end)