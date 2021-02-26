local env = env
GLOBAL.setfenv(1, GLOBAL)

env.AddPlayerPostInit(function(inst)
	inst:AddTag("UM_foodregen")
	
	if not TheWorld.ismastersim then
		return
	end

    local function oneat(inst, data)
		inst.components.eater:SetAbsorptionModifiers(0, 1, 0)
		
		local strongstomach = inst.components.eater.strongstomach and data.food:HasTag("monstermeat")
		local wurtfoodshealth = data.food.components.edible:GetHealth() < 0 and inst:HasTag("playermerm") and (data.food.prefab == ("kelp" or "kelp_cooked" or "durian" or "durian_cooked"))
		local wurtfoodssanity = data.food.components.edible:GetSanity() < 0 and inst:HasTag("playermerm") and (data.food.prefab == ("kelp" or "kelp_cooked" or "durian" or "durian_cooked"))
		
		local base_mult = inst.components.foodmemory ~= nil and inst.components.foodmemory:GetFoodMultiplier(data.food.prefab) or (inst:HasTag("souleater") and 0.5) or 1
		local warlybuff = inst:HasTag("warlybuffed") and 1.2 or 1

		if inst.prefab == "wx78" then
			if data.food.components.edible.healthvalue ~= nil and data.food.components.edible.healthvalue > 3 then
				inst.components.debuffable:AddDebuff("healthregenbuff_vetcurse_"..data.food.prefab, "healthregenbuff_vetcurse", {duration = (data.food.components.edible.healthvalue * 0.1)})
			else
				inst.components.health:DoDelta(data.food.components.edible.healthvalue)
			end
			
			if data.food.components.edible.sanityvalue ~= nil and data.food.components.edible.sanityvalue > 3 then
				inst.components.debuffable:AddDebuff("sanityregenbuff_vetcurse_"..data.food.prefab, "sanityregenbuff_vetcurse", {duration = (data.food.components.edible.sanityvalue * 0.1)})
			else
				inst.components.sanity:DoDelta(data.food.components.edible.sanityvalue)
			end
		else
			if not inst:HasTag("plantkin") and data.food.components.edible:GetHealth() ~= nil and ((data.food.components.edible:GetHealth() * base_mult) * warlybuff) > 3 then
				inst.components.debuffable:AddDebuff("healthregenbuff_vetcurse_"..data.food.prefab, "healthregenbuff_vetcurse", {duration = ((data.food.components.edible:GetHealth() * base_mult) * warlybuff) * 0.1})
			elseif not inst:HasTag("plantkin") and not strongstomach and not wurtfoodshealth then
				inst.components.health:DoDelta((data.food.components.edible:GetHealth() * base_mult) * warlybuff, data.food.prefab)
			end
			
			if data.food.components.edible:GetSanity() ~= nil and ((data.food.components.edible:GetSanity() * base_mult) * warlybuff) > 3 then
				inst.components.debuffable:AddDebuff("sanityregenbuff_vetcurse_"..data.food.prefab, "sanityregenbuff_vetcurse", {duration = ((data.food.components.edible:GetSanity() * base_mult) * warlybuff) * 0.1})
			elseif not strongstomach and not wurtfoodssanity then
				inst.components.sanity:DoDelta((data.food.components.edible:GetSanity() * base_mult) * warlybuff)
			end
		end
	end

	inst.components.eater:SetAbsorptionModifiers(0, 1, 0)

	inst:ListenForEvent("oneat", oneat)
end)