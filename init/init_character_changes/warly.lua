local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
local function oneat(inst, food)
	if food and food.components.edible then
		local hungerbonus = food.components.edible:GetHunger() * 0.2
		local sanitybonus = food.components.edible:GetSanity() * 0.2
		local healthbonus = food.components.edible:GetHealth() * 0.2
		
		if inst.components.hunger and hungerbonus > 0 then
			inst.components.hunger:DoDelta(hungerbonus)
		end
		
		if not inst:HasTag("vetcurse") and  inst.components.sanity and sanitybonus > 0 then
			inst.components.sanity:DoDelta(hungerbonus)
		end
		
		if not inst:HasTag("vetcurse") and  inst.components.health and healthbonus > 0 then
			inst.components.health:DoDelta(hungerbonus, food.prefab)
		end
		
	end
end

env.AddPrefabPostInit("warly", function(inst) 
	if not TheWorld.ismastersim then
		return
	end
	
	inst:AddTag("warlybuffed")
	
	if inst.components.eater ~= nil then
		inst.components.eater:SetOnEatFn(oneat)
		--inst.components.eater:SetAbsorptionModifiers(1.2, 1.15, 1.2)
	end
	
	if inst.components.foodmemory ~= nil then
		inst.components.foodmemory:SetDuration(TUNING.DSTU.WARLY_SAME_OLD_COOLDOWN)
		inst.components.foodmemory:SetMultipliers(TUNING.DSTU.WARLY_SAME_OLD_MULTIPLIERS)
	end
end)

