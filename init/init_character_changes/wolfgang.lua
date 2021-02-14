-----------------------------------------------------------------
-- Wolfgang scaredy cat bonus is increased significantly
-----------------------------------------------------------------
--[[local function speedcheck(inst)
	if inst.strength == "mighty" then
		if inst.components.locomotor ~= nil then
			inst.components.locomotor.walkspeed = TUNING.WILSON_WALK_SPEED / 1.2
			inst.components.locomotor.runspeed = TUNING.WILSON_RUN_SPEED / 1.2
		end
	else
		if inst.components.locomotor ~= nil then
			inst.components.locomotor.walkspeed = TUNING.WILSON_WALK_SPEED
			inst.components.locomotor.runspeed = TUNING.WILSON_RUN_SPEED
		end
	end
end


local function speedcheck(inst)
    if inst.strength == "mighty" then
		if inst.components.locomotor ~= nil then
			inst.components.locomotor:SetExternalSpeedMultiplier(inst, "ToroicIsMegaCool", 1 / inst._mightiness_scale)
		end
		inst:AddTag("fat_gang")
    else
		if inst.components.locomotor ~= nil then
			inst.components.locomotor:RemoveExternalSpeedMultiplier(inst, "ToroicIsMegaCool")
		end
		inst:RemoveTag("fat_gang")
    end
end

AddPrefabPostInit("wolfgang", function(inst)
	if not GLOBAL.TheWorld.ismastersim then
		return
	end
	
    if inst ~= nil and inst.components.sanity ~= nil then    
        inst.components.sanity.night_drain_mult = GLOBAL.TUNING.DSTU.WOLFGANG_SANITY_MULTIPLIER
        inst.components.sanity.neg_aura_mult = GLOBAL.TUNING.DSTU.WOLFGANG_SANITY_MULTIPLIER
    end
	
	inst:ListenForEvent("hungerdelta", speedcheck)
end)

--TODO add a "scared" animation from time to time, as a flavour--]]

local require = GLOBAL.require
local UpvalueHacker = require("tools/upvaluehacker")
local easing = require("easing")

--Mighty form changes
TUNING.WOLFGANG_HEALTH_MIGHTY = 200
TUNING.WOLFGANG_HUNGER_RATE_MULT_MIGHTY = 2
TUNING.WOLFGANG_ROW_MULT = 10

--Normal form changes
TUNING.WOLFGANG_ATTACKMULT_NORMAL = 1.25

--Affect all forms
TUNING.WOLFGANG_GOCRAZY_PERCENT = 0.1
TUNING.WOLFGANG_REWORK_SANITYMAX = 150
TUNING.WOLFGANG_SANITYDRAIN = 1.3


local TheNet = GLOBAL.TheNet

local function patch(name)
	modimport("patches/"..name..".lua")
end

-- Workaround for socketing/repairing heavy objects while mighty

local _RepairFn = GLOBAL.ACTIONS.REPAIR.fn

GLOBAL.ACTIONS.REPAIR.fn = function(act)
	if act.doer ~= nil and 
		act.target ~= nil and 
		act.target.components.repairable ~= nil and 
		act.doer.components.inventory ~= nil then
		
		local testmaterial = act.doer.components.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.BODY)
		
		if testmaterial ~= nil and testmaterial:HasTag("washeavy") then 
			if testmaterial.components.repairer ~= nil then
				return act.target.components.repairable:Repair(act.doer, testmaterial)
			end
		else
			_RepairFn(act)
		end
	else
	_RepairFn(act)
	end
end

AddComponentAction("SCENE", "repairable", function(inst, doer, actions, right)
    if right and
		doer.replica.inventory ~= nil then 
		
		local item = doer.replica.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.BODY)
		
		if item ~= nil and
			item:HasTag("washeavy") then
			if (inst:HasTag("repairable_sculpture") and item:HasTag("work_sculpture"))
					or (inst:HasTag("repairable_moon_altar") and item:HasTag("work_moon_altar")) then
				table.insert(actions, GLOBAL.ACTIONS.REPAIR)
			end
		end
	end
end)

if not TheNet:GetIsServer() then return end

--Credit to Rezecib's Rebalance for Wolfgang being able to cancel the animation code.
AddStategraphPostInit("wilson", function(sg)
	sg.states.powerup.tags.busy = nil
	sg.states.powerup.tags.pausepredict = nil
	sg.states.powerdown.tags.busy = nil
	sg.states.powerdown.tags.pausepredict = nil
end)

local function CheckInsane(inst)
	if inst.components.sanity ~= nil then
		if (inst.components.sanity.current/inst.components.sanity.max < TUNING.WOLFGANG_GOCRAZY_PERCENT) then
            inst.components.sanity:SetInducedInsanity(inst, true)
		else
			inst.components.sanity:SetInducedInsanity(inst, false)
		end
	end
	
end

local function FixItem(inst, data)
	local thing = data.item
	if thing ~= nil then
		if thing.components.oar ~= nil and thing:HasTag("strongoar") then
			thing:RemoveTag("strongoar")
			thing.components.oar.force = thing.components.oar.force / TUNING.WOLFGANG_ROW_MULT
		end
	end
end

local function DropItem(inst, data)
	local thing = data.item
	if thing ~= nil then
		if thing:HasTag("washeavy") then
			thing:RemoveTag("washeavy")
			thing:AddTag("heavy")
		end
	end
end

local function NewItem(inst, data)
	local thing = data.item
	if inst.strength == "mighty" then
		if thing ~= nil then
			if thing:HasTag("heavy")then
				inst:DoTaskInTime(0.3, function() 
					thing:RemoveTag("heavy")
					thing:AddTag("washeavy")
					inst.components.inventory:Equip(thing)
				end)
			end
		end
	end
end


local function StrongmanPickup(inst)
	local itemhead = inst.components.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.HEAD)
	local itembody = inst.components.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.BODY)
	local itemhand = inst.components.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.HANDS)
	

	
	if itemhand ~= nil then
		if itemhand.components.oar ~= nil then
			if inst.strength == "mighty" and not itemhand:HasTag("strongoar") then
				itemhand:AddTag("strongoar")
				itemhand.components.oar.force = itemhand.components.oar.force * TUNING.WOLFGANG_ROW_MULT
			elseif inst.strength ~= "mighty" and itemhand:HasTag("strongoar") then
				itemhand:RemoveTag("strongoar")
				itemhand.components.oar.force = itemhand.components.oar.force / TUNING.WOLFGANG_ROW_MULT
			end
		end
	end
	
	if inst.strength ~= "wimpy" and not inst.components.rider.riding then
	
		--counteracts head slowdown
		if itemhead ~= nil then 	
			local itemheadspeed = itemhead.components.equippable.walkspeedmult

			if itemheadspeed and itemheadspeed <= 1 then
				inst.components.locomotor:SetExternalSpeedMultiplier(inst, "strongmanhead", (1/itemheadspeed))
			end
		else 
			inst.components.locomotor:RemoveExternalSpeedMultiplier(inst, "strongmanhead")
		end
		
		--counteracts body slowdown
		if itembody ~= nil then 	
			local itembodyspeed = itembody.components.equippable.walkspeedmult

			if itembodyspeed and itembodyspeed <= 1 then
				inst.components.locomotor:SetExternalSpeedMultiplier(inst, "strongmanbody", (1/itembodyspeed))
			end
		else 
			inst.components.locomotor:RemoveExternalSpeedMultiplier(inst, "strongmanbody")
		end
		
		--counteracts hand slowdown (currently only for mod compatibility)
		if itemhand ~= nil then 	
			local itemhandspeed = itemhand.components.equippable.walkspeedmult

			if itemhandspeed and itemhandspeed <= 1 then
				inst.components.locomotor:SetExternalSpeedMultiplier(inst, "strongmanhand", (1/itemhandspeed))
			end
		else 
			inst.components.locomotor:RemoveExternalSpeedMultiplier(inst, "strongmanhand")
		end		
	else --inst.strength == "wimpy"
		inst.components.locomotor:RemoveExternalSpeedMultiplier(inst, "strongmanhead")
		inst.components.locomotor:RemoveExternalSpeedMultiplier(inst, "strongmanbody")
		inst.components.locomotor:RemoveExternalSpeedMultiplier(inst, "strongmanhand")
	end
	
	if inst.strength == "normal" and itembody ~= nil then
		
		if itembody:HasTag("washeavy") then
			inst.components.inventory:DropItem(itembody)
		end
		
		if inst.components.inventory:IsHeavyLifting() and not inst.components.rider.riding then
			inst.components.locomotor:SetExternalSpeedMultiplier(inst, "strongmancarry", (TUNING.HEAVY_SPEED_MULT*3))
		end
	else
		inst.components.locomotor:RemoveExternalSpeedMultiplier(inst, "strongmancarry")
	end
end

AddPrefabPostInit("world", function(inst)
	local function applymightiness(inst)
    local percent = inst.components.hunger:GetPercent()

    local damage_mult = TUNING.WOLFGANG_ATTACKMULT_NORMAL
    local hunger_rate = TUNING.WOLFGANG_HUNGER_RATE_MULT_NORMAL
    local health_max = TUNING.WOLFGANG_HEALTH_NORMAL

    if inst.strength == "mighty" then
        local mighty_start = (TUNING.WOLFGANG_START_MIGHTY_THRESH/TUNING.WOLFGANG_HUNGER)
        local mighty_percent = math.max(0, (percent - mighty_start) / (1 - mighty_start))
        damage_mult = easing.linear(mighty_percent, TUNING.WOLFGANG_ATTACKMULT_MIGHTY_MIN, TUNING.WOLFGANG_ATTACKMULT_MIGHTY_MAX - TUNING.WOLFGANG_ATTACKMULT_MIGHTY_MIN, 1)
        health_max = TUNING.WOLFGANG_HEALTH_NORMAL
        hunger_rate = easing.linear(mighty_percent, TUNING.WOLFGANG_HUNGER_RATE_MULT_NORMAL, TUNING.WOLFGANG_HUNGER_RATE_MULT_MIGHTY - TUNING.WOLFGANG_HUNGER_RATE_MULT_NORMAL, 1)
		inst:AddTag("fat_gang")
	elseif inst.strength == "wimpy" then
        local wimpy_start = (TUNING.WOLFGANG_START_WIMPY_THRESH/TUNING.WOLFGANG_HUNGER)
        local wimpy_percent = math.min(1, percent / wimpy_start)
        damage_mult = easing.linear(wimpy_percent, TUNING.WOLFGANG_ATTACKMULT_WIMPY_MIN, TUNING.WOLFGANG_ATTACKMULT_WIMPY_MAX - TUNING.WOLFGANG_ATTACKMULT_WIMPY_MIN, 1)
        health_max = easing.linear(wimpy_percent, TUNING.WOLFGANG_HEALTH_WIMPY, TUNING.WOLFGANG_HEALTH_NORMAL - TUNING.WOLFGANG_HEALTH_WIMPY, 1)
        hunger_rate = easing.linear(wimpy_percent, TUNING.WOLFGANG_HUNGER_RATE_MULT_WIMPY, TUNING.WOLFGANG_HUNGER_RATE_MULT_NORMAL - TUNING.WOLFGANG_HUNGER_RATE_MULT_WIMPY, 1)
		inst:RemoveTag("fat_gang")
	else
		inst:RemoveTag("fat_gang")
	end
    inst.components.hunger:SetRate(hunger_rate*TUNING.WILSON_HUNGER_RATE)
    inst.components.combat.damagemultiplier = damage_mult

    local health_percent = inst.components.health:GetPercent()
    inst.components.health:SetMaxHealth(health_max)
    inst.components.health:SetPercent(health_percent, true)

    if inst.components.inventory:IsHeavyLifting() then
        StrongmanPickup(inst)
    end
end
	
	UpvalueHacker.SetUpvalue(GLOBAL.Prefabs.wolfgang.fn, applymightiness, "master_postinit", "onload", "onbecamehuman", "onhungerchange", "applymightiness")
	end)

--This is used to fix an issue with mounting beefalo in normal form causing slowdown
local function MountFix(inst)
	inst.components.locomotor:RemoveExternalSpeedMultiplier(inst, "strongmancarry")
end

AddPrefabPostInit("wolfgang", function(inst)
    
	if inst ~= nil and inst.components.sanity ~= nil then    
		inst.components.sanity:SetMax(TUNING.WOLFGANG_REWORK_SANITYMAX)
		inst.components.sanity.night_drain_mult = TUNING.WOLFGANG_SANITYDRAIN
		inst.components.sanity.neg_aura_mult = TUNING.WOLFGANG_SANITYDRAIN
	end
	
	--sanity trigger
	inst:ListenForEvent("sanitydelta",CheckInsane)

	--item related triggers
    inst:ListenForEvent("equip", StrongmanPickup)
    inst:ListenForEvent("unequip", StrongmanPickup)
	inst:ListenForEvent("newstate", StrongmanPickup)
	inst:ListenForEvent("equip", NewItem)
	inst:ListenForEvent("dropitem", DropItem)
	inst:ListenForEvent("unequip", FixItem)
	inst:ListenForEvent("mounted", MountFix)
	
end)