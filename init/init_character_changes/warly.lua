local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------	

env.AddPrefabPostInit("warly", function(inst) 
	if not TheWorld.ismastersim then
		return
	end

if TUNING.DSTU.WARLY_BUTCHER then
	--local function onbutchered(target, data)
		--local target = data.target
		--if target ~= nil and not target:HasTag("butchermark") then
			--target:AddTag("butchermark")
		--end	
		--if target ~= nil and target.butcher_cancel_task ~= nil then
			--target.butcher_cancel_task:Cancel()
			--target.butcher_cancel_task = nil
		--end
		--target.butcher_cancel_task = target:DoTaskInTime(3, function() target:RemoveTag("butchermark") end)
	--end

	local function inventorystuff(item, data)
		local item = data.item
		if item ~= nil and ((item.components.health and item.components.inventoryitem.canbepickedupalive == true) or item.components.weighable ~= nil) and not item:HasTag("butchermark") then
			item:AddTag("butchermark")
		end
		if item ~= nil and item.butcher_cancel_task ~= nil then
			item.butcher_cancel_task:Cancel()
			item.butcher_cancel_task = nil
		end
	end

	local function ondropitem(item, data)
		local item = data.item
		if item ~= nil and item:HasTag("butchermark") then
			item:RemoveTag("butchermark")
		end
	end
	
	if inst.components.combat ~= nil then
		--inst:ListenForEvent("onattackother", onbutchered)
		inst:ListenForEvent("itemget", inventorystuff)
		inst:ListenForEvent("inventoryfull", inventorystuff)
		inst:ListenForEvent("gotnewitem", inventorystuff)
		inst:ListenForEvent("dropitem", ondropitem)
		inst:ListenForEvent("itemlose", ondropitem)
	end
end

if TUNING.DSTU.WARLY_FOOD_TASTE then
	local function oneat(inst, data)
		local food = data.food
		if food and food.components.edible then
			local hungerbonus = food.components.edible:GetHunger() * 0.2
			local sanitybonus = food.components.edible:GetSanity() * 0.2
			local healthbonus = food.components.edible:GetHealth() * 0.2
			
			if inst.components.hunger and hungerbonus > 0 then
				inst.components.hunger:DoDelta(hungerbonus)
			end
			
			if not inst:HasTag("vetcurse") and not inst:HasTag("UM_foodregen") and inst.components.sanity and sanitybonus > 0 then
				inst.components.sanity:DoDelta(sanitybonus)
			end
			
			if not inst:HasTag("vetcurse") and not inst:HasTag("UM_foodregen") and inst.components.health and healthbonus > 0 then
				inst.components.health:DoDelta(healthbonus, true, food.prefab)
			end
		end
	end
	
	inst:AddTag("warlybuffed")
		
	if inst.components.eater ~= nil then
		inst:ListenForEvent("oneat", oneat)
		--inst.components.eater:SetOnEatFn(oneat)
		--inst.components.eater:SetAbsorptionModifiers(1.2, 1.2, 1.2)
	end
		
	if inst.components.foodmemory ~= nil then
		inst.components.foodmemory:SetDuration(TUNING.DSTU.WARLY_SAME_OLD_COOLDOWN)
		inst.components.foodmemory:SetMultipliers(TUNING.DSTU.WARLY_SAME_OLD_MULTIPLIERS)
	end
end

end)
