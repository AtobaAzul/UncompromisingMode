local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

local function DoEffects(pet)
    local x, y, z = pet.Transform:GetWorldPosition()
    SpawnPrefab("statue_transition_2").Transform:SetPosition(x, y, z)
end

--[[local function doeffects(inst, pos)
    SpawnPrefab("statue_transition").Transform:SetPosition(pos:Get())
    SpawnPrefab("statue_transition_2").Transform:SetPosition(pos:Get())
end]]


local function CalculateMaxHealthLoss(inst, data)
	if inst.components.health ~= nil and not inst.components.health:IsDead() then
		local healthloss = ((data.damageresolved ~= nil and data.damageresolved or data.damage) * 0.2) / 75
		inst.components.health:DeltaPenalty(healthloss)
	end
end

local function KillPet(pet)
    pet.components.health:Kill()
end

local function OnSpawnPet(inst, pet)
    if pet:HasTag("classicshadow") then
        --Delayed in case we need to relocate for migration spawning
        pet:DoTaskInTime(0, DoEffects)

        if not (inst.components.health:IsDead() or inst:HasTag("playerghost")) then
            inst.components.sanity:AddSanityPenalty(pet, TUNING.DSTU.OLD_SHADOWWAXWELL_SANITY_PENALTY)
            inst:ListenForEvent("onremove", inst._onpetlost, pet)
        elseif pet._killtask == nil then
            pet._killtask = pet:DoTaskInTime(math.random(), KillPet)
        end
    else
        return inst.OldSpawnPet(inst, pet)
    end
end

env.AddPrefabPostInit("waxwell", function(inst) 
	if not TheWorld.ismastersim then
		return
	end
	
	inst:AddTag("codexumbrareader")
	
	if inst.components.petleash ~= nil then
		inst.OldSpawnPet = inst.components.petleash.onspawnfn
		inst.components.petleash:SetOnSpawnFn(OnSpawnPet)
	end	
	
	if TUNING.DSTU.MAX_HEALTH_WELL == true then
		inst:ListenForEvent("attacked", CalculateMaxHealthLoss)
	end
end)

local function canread(inst, reader)
    return (inst.components.sanity:GetMaxWithPenalty() >= TUNING.DSTU.OLD_SHADOWWAXWELL_SANITY_COST) and (inst.components.health.currenthealth > TUNING.DSTU.SHADOWWAXWELL_HEALTH_COST)
end

local function onread(inst, reader)

	if not reader:HasTag("codexumbrareader") then
		return false
	end
	
    --Check sanity
    if not canread(reader) then 
        if reader.components.talker then
			if reader.components.sanity:GetMaxWithPenalty() < TUNING.DSTU.OLD_SHADOWWAXWELL_SANITY_COST then
				reader.components.talker:Say(GetString(reader.prefab, "ANNOUNCE_NOSANITY"))
			elseif reader.components.health.currenthealth <= TUNING.DSTU.SHADOWWAXWELL_HEALTH_COST then
				reader.components.talker:Say(GetString(reader.prefab, "ANNOUNCE_NOHEALTH"))
			end
            return true
        end
    end

    --Check reagent
    if not reader.components.inventory:Has("nightmarefuel", TUNING.DSTU.SHADOWWAXWELL_FUEL_COST) then
        if reader.components.talker then
            reader.components.talker:Say(GetString(reader.prefab, "ANNOUNCE_NOFUEL"))
            return true
        end
    end


	local readx, ready, readz = reader.Transform:GetWorldPosition()
	local shadowmax = reader.components.petleash:SpawnPetAt(readx, ready, readz, "old_shadowwaxwell")
	
	if shadowmax ~= nil then
		reader.components.inventory:ConsumeByName("nightmarefuel", TUNING.DSTU.SHADOWWAXWELL_FUEL_COST)
		shadowmax:DoTaskInTime(0, function(shadowmax) shadowmax.sg:GoToState("jumpout") end)
		reader.components.health:DoDelta(-TUNING.DSTU.SHADOWWAXWELL_HEALTH_COST)
		reader.components.sanity:RecalculatePenalty()
		inst.SoundEmitter:PlaySound("dontstarve/maxwell/shadowmax_appear")
	end
	
	return true
end

env.AddPrefabPostInit("waxwelljournal", function(inst)

	if not TheWorld.ismastersim then
		return
	end
	
	if inst.components.prototyper ~= nil then
		--inst.components.prototyper.trees = TUNING.PROTOTYPER_TREES.PRESTIHATITATOR
	end

    inst:AddComponent("book")
    inst.components.book.onread = onread

end)