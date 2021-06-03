local env = env
GLOBAL.setfenv(1, GLOBAL)

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
	
	print(inst.healthabsorption, inst.hungerabsorption, inst.sanityabsorption)

	inst.components.eater:SetAbsorptionModifiers(0, inst.hungerabsorption or 1, 0)
		
	local strongstomach = inst.components.eater.strongstomach and data.food:HasTag("monstermeat")
	local wurtfoodshealth = data.food.components.edible:GetHealth() < 0 and inst:HasTag("playermerm") and (data.food.prefab == "kelp" or data.food.prefab == "kelp_cooked" or data.food.prefab == "durian" or data.food.prefab == "durian_cooked")
	local wurtfoodssanity = data.food.components.edible:GetSanity() < 0 and inst:HasTag("playermerm") and (data.food.prefab == "kelp" or data.food.prefab == "kelp_cooked" or data.food.prefab == "durian" or data.food.prefab == "durian_cooked")
		
	local foodmemorybuff = inst.components.foodmemory ~= nil and inst.components.foodmemory:GetFoodMultiplier(data.food.prefab) or 1
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
		if not inst:HasTag("plantkin") and data.food.components.edible:GetHealth() ~= nil and (((data.food.components.edible:GetHealth() * foodmemorybuff) * warlybuff) * inst.healthabsorption) > 3 then
			inst.components.debuffable:AddDebuff("healthregenbuff_vetcurse_"..data.food.prefab, "healthregenbuff_vetcurse", {duration = (((data.food.components.edible:GetHealth() * foodmemorybuff) * warlybuff) * inst.healthabsorption) * 0.1})
		elseif not inst:HasTag("plantkin") and not strongstomach and not wurtfoodshealth then
			inst.components.health:DoDelta(((data.food.components.edible:GetHealth() * foodmemorybuff) * warlybuff) * inst.healthabsorption, data.food.prefab)
		end
		
		if data.food.components.edible:GetSanity() ~= nil and (((data.food.components.edible:GetSanity() * foodmemorybuff) * warlybuff) * inst.sanityabsorption) > 3 then
			inst.components.debuffable:AddDebuff("sanityregenbuff_vetcurse_"..data.food.prefab, "sanityregenbuff_vetcurse", {duration = (((data.food.components.edible:GetSanity() * foodmemorybuff) * warlybuff) * inst.sanityabsorption) * 0.1})
		elseif not strongstomach and not wurtfoodssanity then
			inst.components.sanity:DoDelta(((data.food.components.edible:GetSanity() * foodmemorybuff) * warlybuff) * inst.sanityabsorption)
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