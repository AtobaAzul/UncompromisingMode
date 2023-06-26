local prefabs = {
	"umdebuff_pyre_toxin_fx"
}


-- Default duration is pretty short. This can be changed by whatever inflicts the debuff, by passing data after the debuff name and prefab.
local DebuffDuration = 6


local function debuff_OnDetached(inst, target)
	if target ~= nil and target:IsValid() and target.components.temperature ~= nil then
		target.components.temperature:RemoveModifier("umdebuff_pyre_toxin")
	end
	
	if inst.fx ~= nil then
		if inst.fx:IsValid() then
		--	inst.fx:Remove()
			ErodeAway(inst.fx, 60*FRAMES)
		end
	end
	
	inst:DoTaskInTime(0, function()
		inst:Remove()
	end)
end


local function DamageTarget(inst, target)
	if target.components.health.currenthealth > 15 then
		target.components.health:DoDelta(-15, false, "umdebuff_pyre_toxin")
	end
end

local function debuff_OnAttached(inst, target, followsymbol, followoffset, data)
	if target ~= nil
	and (target.components.temperature ~= nil or target.components.health ~= nil)
	and (inst.components.debuff.name == "umdebuff_pyre_toxin_armor_wearer" or not target:HasTag("PyreToxinImmune"))
	and not target:HasTag("plantkin")
	and not target:HasTag("dragonfly")
	and not target:HasTag("lavae")
	and not target:HasTag("butterfly")
	and not (target:HasTag("bee") and not target:HasTag("monster"))
	and not target:HasTag("wall")
	and not target:HasTag("structure")
--	and not target:HasTag("scorpion")
	and target.prefab ~= "firehound"
	then
		-- Basic debuff stuff.
		inst.entity:SetParent(target.entity)
		inst.Transform:SetPosition(0, 0, 0)
		if data ~= nil then
			DebuffDuration = data
		end
		inst.components.timer:StartTimer("pyretoxinduration", DebuffDuration)
		inst:ListenForEvent("death", function()
			inst.components.debuff:Stop()
		end, target)
		
		-- Player negatives here.
		if target:HasTag("player")
		and not target:HasTag("playerghost")
		and target.components.temperature ~= nil
		then
			-- Heat.
			if target.components.temperature:GetCurrent() < 65 then
				target.components.temperature:SetTemperature(64)
			end
			
			target.components.temperature:SetModifier("umdebuff_pyre_toxin", TUNING.FIRE_NETTLE_TOXIN_TEMP_MODIFIER)
		end
		
		-- Mob negatives here.
		if not target:HasTag("player") then
			-- Damage.
			if target.components.health ~= nil and not target.components.health:IsDead() then
				inst:DoPeriodicTask(1, DamageTarget, 0, target)
			end
			
			-- Panic.
			if target.components.hauntable ~= nil and target.components.hauntable.panicable then
				if target:HasTag("epic") then
					target.components.hauntable:Panic(3)
				else
					target.components.hauntable:Panic(5)
				end
			end
			-- Trying to figure out how to do it without relying on hauntable...
			--if target.brain ~= nil then
			--	target.brain:PanicTrigger(target)
			--end
		end
		
		-- Begin the visual effects.
		if inst.fx == nil or not inst.fx:IsValid() then
			inst.fx = SpawnPrefab("umdebuff_pyre_toxin_fx")
		end
		if target.components.combat ~= nil then
			inst.fx.entity:AddFollower():FollowSymbol(target.GUID, target.components.combat.hiteffectsymbol, 0, -1, 0)
		else
			inst.fx.entity:SetParent(target.entity)
		end
		if target:HasTag("smallcreature") then
			inst.fx.Transform:SetScale(0.5, 0.5, 0.5)
		end
		
		-- Say the line...
		if target:HasTag("player")
		and target.components.talker ~= nil
		and target.components.health ~= nil and not target.components.health:IsDead()
		and target:HasTag("idle") then
			if inst.components.debuff.name ~= "umdebuff_pyre_toxin_armor_wearer"
			or (inst.components.debuff.name == "umdebuff_pyre_toxin_armor_wearer" and math.random() > 0.75)
			then
				target.components.talker:Say(GetString(target, "ANNOUNCE_FIRENETTLE_TOXIN")) -- Change this if the toxin is ever applied by non-nettles.				
			end
		end
	else
		inst:Remove()
	end
end

local function debuff_OnExtended(inst, target, followsymbol, followoffset, data)
	-- This sets the incomming debuff's duration.
	if data ~= nil then
		DebuffDuration = data
	end
	
	-- Check how long we have left on our already-existing debuff, if there is one.
	local time_remaining = inst.components.timer:GetTimeLeft("pyretoxinduration")
	
	if time_remaining ~= nil then
		if DebuffDuration > time_remaining then
			inst.components.timer:SetTimeLeft("pyretoxinduration", DebuffDuration)
		end
	else
		inst.components.timer:StartTimer("pyretoxinduration", DebuffDuration)
	end
end

local function OnTimerDone(inst, data)
	if data.name == "pyretoxinduration" then
		inst.components.debuff:Stop()
	end
end


local function fn()
	local inst = CreateEntity()
	
	if not TheWorld.ismastersim then
		--Not meant for client!
		inst:Remove()
		
		return inst
	end
	
	inst.entity:AddTransform()
	
	--[[Non-networked entity]]
	inst.entity:Hide()
	
	inst:AddComponent("debuff")
	inst.components.debuff:SetAttachedFn(debuff_OnAttached)
	inst.components.debuff:SetDetachedFn(debuff_OnDetached)
	inst.components.debuff:SetExtendedFn(debuff_OnExtended)
	inst.components.debuff.keepondespawn = false
	
	inst:AddComponent("timer")
	inst:ListenForEvent("timerdone", OnTimerDone)
	
	return inst
end


local function fx_fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()
	
	inst:AddTag("FX")
	inst:AddTag("NOCLICK")
	
	inst.AnimState:SetBank("umdebuff_pyre_toxin_fx")
	inst.AnimState:SetBuild("umdebuff_pyre_toxin_fx")
	inst.Transform:SetScale(1.5, 1.5, 1.5)
	inst.AnimState:SetMultColour(1, 1, 1, 0.85)
	inst.AnimState:PlayAnimation("idle", true)
	
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst.persists = false
	
	return inst
end

return Prefab("umdebuff_pyre_toxin", fn, nil, prefabs),
	Prefab("umdebuff_pyre_toxin_fx", fx_fn)
