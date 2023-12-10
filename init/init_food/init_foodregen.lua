local env = env
GLOBAL.setfenv(1, GLOBAL)

local function oneat(inst, data)
	if not inst:HasTag("vetcurse") then
		if inst.modded_healthabsorption == nil then
			inst.modded_healthabsorption = inst.components.eater.healthabsorption
		end
				
		if inst.modded_hungerabsorption == nil then
			inst.modded_hungerabsorption = inst.components.eater.hungerabsorption
		end
				
		if inst.modded_sanityabsorption == nil then
			inst.modded_sanityabsorption = inst.components.eater.sanityabsorption
		end
			
		inst.components.eater:SetAbsorptionModifiers(0, inst.modded_hungerabsorption or 1, 0)
			
		local stack_mult = inst.components.eater.eatwholestack and data.food.components.stackable ~= nil and data.food.components.stackable:StackSize() or 1
		local maxhp_heal = string.find(data.food.prefab, "spice_salt") ~= nil
		local base_mult = inst.components.foodmemory ~= nil and inst.components.foodmemory:GetFoodMultiplier(data.food.prefab) or 1
		local warlybuff = inst:HasTag("warlybuffed") and 1.2 or 1

		local health_delta = 0
		local sanity_delta = 0
		local hunger_delta = 0
			
		if inst.components.health ~= nil and
			(data.food.components.edible.healthvalue >= 0 or inst.components.eater:DoFoodEffects(data.food)) then
			health_delta = data.food.components.edible:GetHealth(inst) * base_mult * inst.modded_healthabsorption * warlybuff
		end
			
		if inst.components.sanity ~= nil and
			(data.food.components.edible.sanityvalue >= 0 or inst.components.eater:DoFoodEffects(data.food)) then
			sanity_delta = data.food.components.edible:GetSanity(inst) * base_mult * inst.modded_sanityabsorption * warlybuff
		end
		
		if inst.components.eater.custom_stats_mod_fn ~= nil then
			health_delta, hunger_delta, sanity_delta = inst.components.eater.custom_stats_mod_fn(inst, health_delta, hunger_delta, sanity_delta, data.food, data.feeder)
		end

		local foodaffinitysanitybuff = inst:HasTag("playermerm") and (data.food.prefab == "kelp" or data.food.prefab == "kelp_cooked") and 0 or inst.components.foodaffinity:HasPrefabAffinity(data.food) and 15 or 0
		sanity_delta = sanity_delta + foodaffinitysanitybuff
			
		if inst:HasTag("wathom") and inst.components.foodaffinity:HasPrefabAffinity(data.food) then
			health_delta = health_delta + 20
		end

		if health_delta > 3 then
			inst.components.debuffable:AddDebuff("healthregenbuff_vetcurse_"..data.food.prefab, "healthregenbuff_vetcurse", {duration = (health_delta * 0.1), max_hp = maxhp_heal})
		else
			inst.components.health:DoDelta(health_delta)
		end
			
		if sanity_delta > 3 then
			inst.components.debuffable:AddDebuff("sanityregenbuff_vetcurse_"..data.food.prefab, "sanityregenbuff_vetcurse", {duration = (sanity_delta * 0.1)})
		else
			inst.components.sanity:DoDelta(sanity_delta)
		end
	end
end

env.AddPlayerPostInit(function(inst)
	inst:AddTag("UM_foodregen")
	
	if not TheWorld.ismastersim then
		return
	end

	if inst.modded_healthabsorption == nil then
		inst.modded_healthabsorption = inst.components.eater.healthabsorption
	end

	if inst.modded_hungerabsorption == nil then
		inst.modded_hungerabsorption = inst.components.eater.hungerabsorption
	end
		
	if inst.modded_sanityabsorption == nil then
		inst.modded_sanityabsorption = inst.components.eater.sanityabsorption
	end

	inst.components.eater:SetAbsorptionModifiers(0, inst.modded_hungerabsorption or 1, 0)
		
	inst:ListenForEvent("oneat", oneat)
end)