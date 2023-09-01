local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

local function NewCustom(inst, dt)
	inst.sanitytrail = 0
	
	local x, y, z = inst.Transform:GetWorldPosition()
	local bordomtrails = TheSim:FindEntities(x, y, z, 17, { "bordomtrail" })

	for i, v in ipairs(bordomtrails) do
		if v.sanitylevel ~= nil and  v.ownerid == inst.userid then
			inst.sanitytrail = inst.sanitytrail - v.sanitylevel
		end
	end
	
	local wobystarving = inst.woby ~= nil and inst.woby.wobystarving and -0.1 or 0
	
	local rate = inst._OldRate(inst, dt)

    return rate + inst.sanitytrail + wobystarving
end

local function RightClickPicker(inst, target, pos)

    local actions = {}
    local notexamine = false
	if target ~= nil then
		actions = inst.components.playeractionpicker:GetSceneActions(target, true)
		--CollectActions("SCENE")
		
		--inst:CollectActions("SCENE", target, inst, actions, right)
		
		
		
        for i, v in pairs(actions) do
			if target:IsActionValid(v.action, true) or v.action.rmb or v.action ~= ACTIONS.WALKTO and v.action ~= ACTIONS.LOOKAT and v.action ~= ACTIONS.PICKUP and v.action ~= ACTIONS.DIG and v.action ~= ACTIONS.HARVEST and v.action ~= ACTIONS.PICK and v.action ~= ACTIONS.FEED then
				notexamine = true
			end
		end
	end

    local equipactions = nil
    local validtargetaction = nil
    local useitem = inst.replica.inventory:GetActiveItem() or nil
    local equipitem = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
	
	if equipitem ~= nil and equipitem:IsValid() then
		if target ~= nil then
			equipactions = inst.components.playeractionpicker:GetEquippedItemActions(target, equipitem, true)
			for i, v in pairs(equipactions) do
				validtargetaction = v
			end
		end
	end

	return target ~= nil and
			target ~= inst and
			(inst:GetCurrentPlatform() == nil and not target:HasTag("outofreach") and (TUNING.DSTU.ISLAND_ADVENTURES or target:IsOnPassablePoint()) or target:HasTag("_combat")) and not
			target:HasTag("woby") and not
			target:HasTag("customwobytag") and not
			target:HasTag("shadow") and not
			target:HasTag("shadowcreature") and not
			target:HasTag("shadowminion") and not
			target:HasTag("heavy") and not
			target:HasTag("heavyobject") and not
			target:HasTag("player") and
			validtargetaction == nil and not
			notexamine and
			useitem == nil and
			inst.components.playeractionpicker:SortActionList({ ACTIONS.WOBY_COMMAND }, target, nil)
		or nil, true
end

local function GetPointSpecialActions(inst, pos, useitem, right)
    if right and useitem == nil then
        local rider = inst.replica.rider
		--[[
		local walter = TheSim:FindEntities(pos.x, 0, pos.z, 3, {"pinetreepioneer"})
		for i, v in pairs(walter) do
			if v ~= nil and v == inst then
				if rider ~= nil and rider:IsRiding() then
					print("woby open")
					return { ACTIONS.WOBY_OPEN }
				else
					print("woby open")
					return { ACTIONS.WOBY_HERE }
				end
			end
		end]]
		
		if rider == nil or not rider:IsRiding() then
			local walter = TheSim:FindEntities(pos.x, 0, pos.z, 3, {"pinetreepioneer"})
			for i, v in pairs(walter) do
				if v ~= nil and v == inst then
					return { ACTIONS.WOBY_HERE }
				end
			end
		end

		return { ACTIONS.WOBY_STAY }
	end
	
    return {}
end

local function OnSetOwner(inst)
    if inst.components.playeractionpicker ~= nil then
		inst.components.playeractionpicker.rightclickoverride = RightClickPicker
        inst.components.playeractionpicker.pointspecialactionsfn = GetPointSpecialActions
    end
end

local function OnKilledOther(inst, data)
    if data ~= nil and data.victim ~= nil and data.victim.prefab ~= nil then
        local naughtiness = NAUGHTY_VALUE[data.victim.prefab]
        if naughtiness ~= nil then
			local naughty_val = FunctionOrValue(naughtiness, inst, data)
			local naughtyresolve = naughty_val * (data.stackmult or 1)
			inst.components.sanity:DoDelta(-naughtyresolve)
        end
    end
end

local function Mounted(inst)
	if (inst.replica.rider ~= nil and inst.replica.rider:IsRiding()) and not inst:HasTag("dismounting") 
	and inst.replica.rider:GetMount() ~= nil and inst.replica.rider:GetMount():HasTag("woby") and not
	TheWorld.state.isnight then
		inst:PushEvent("playwobymusic")
	end
end

env.AddPrefabPostInit("walter", function(inst) 

	inst:AddTag("polite")
	inst:RemoveTag("pebblemaker")
	inst:RemoveTag("slingshot_sharpshooter")
	inst:RemoveTag("allow_special_point_action_on_impassable")
	
    inst:ListenForEvent("setowner", OnSetOwner)
	
	inst:DoPeriodicTask(2, Mounted)
	
	if not TheWorld.ismastersim then
		return
	end

	if inst._update_tree_sanity_task ~= nil then
		inst._update_tree_sanity_task:Cancel()
		inst._update_tree_sanity_task = nil
	end

    inst.starting_inventory = {"walterhat", "meatrack_hat", "meat", "monstermeat"}
	
	if inst.components.foodaffinity ~= nil then
		inst.components.foodaffinity:AddPrefabAffinity("meat_dried", TUNING.AFFINITY_15_CALORIES_MED)
		inst.components.foodaffinity:AddPrefabAffinity("smallmeat_dried", TUNING.AFFINITY_15_CALORIES_SMALL)
		inst.components.foodaffinity:AddPrefabAffinity("kelp_dried", TUNING.AFFINITY_15_CALORIES_TINY)
		inst.components.foodaffinity:AddPrefabAffinity("fishmeat_dried", TUNING.AFFINITY_15_CALORIES_MED)
		inst.components.foodaffinity:AddPrefabAffinity("smallfishmeat_dried", TUNING.AFFINITY_15_CALORIES_SMALL)
	end
	
	if inst.components.builder ~= nil then
		inst.components.builder:UnlockRecipe("trap")
		inst.components.builder:UnlockRecipe("birdtrap")
		inst.components.builder:UnlockRecipe("fishingrod")
		inst.components.builder:UnlockRecipe("healingsalve")
		inst.components.builder:UnlockRecipe("bandage")
		inst.components.builder:UnlockRecipe("floral_bandage")
		inst.components.builder:UnlockRecipe("tillweedsalve")
		inst.components.builder:UnlockRecipe("rope")
		inst.components.builder:UnlockRecipe("papyrus")
	end
	
	if inst.components.sanity.custom_rate_fn ~= nil then
		inst._OldRate = inst.components.sanity.custom_rate_fn
		inst.components.sanity.custom_rate_fn = NewCustom
	end
	
	inst:ListenForEvent("killed", OnKilledOther)
end)