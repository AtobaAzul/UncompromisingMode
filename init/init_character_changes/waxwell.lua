local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
local ICON_SCALE = .6
local ICON_RADIUS = 50
local SPELLBOOK_RADIUS = 100
local SPELLBOOK_FOCUS_RADIUS = SPELLBOOK_RADIUS + 2
local NUM_MINIONS_PER_SPAWN = 1

local function _CheckMaxSanity(sanity, minionprefab)
    return sanity ~= nil and
        sanity:GetPenaltyPercent() +
        (TUNING.SHADOWWAXWELL_SANITY_PENALTY[string.upper(minionprefab)] or 0) * NUM_MINIONS_PER_SPAWN <=
        TUNING.MAXIMUM_SANITY_PENALTY
end

local function CheckMaxSanity(doer, minionprefab)
    return _CheckMaxSanity(doer.components.sanity, minionprefab)
end

--I don't know why Klei does this, but i'm not gonna ask.

local function SpellCost(pct)
    return pct * TUNING.LARGE_FUEL * -4
end

local function ShadowMimicSpellFn(inst, doer)
    if inst.components.fueled:IsEmpty() then
        return false, "NO_FUEL"
    elseif doer.components.health.currenthealth <= TUNING.DSTU.SHADOWWAXWELL_HEALTH_COST then
        doer.components.talker:Say(GetString(doer.prefab, "ANNOUNCE_NOHEALTH"))
    elseif not CheckMaxSanity(doer, "shadowduelist") then
        return false, "NO_MAX_SANITY"
    else
        local x, y, z = doer.Transform:GetWorldPosition()
        local shadowmax = doer.components.petleash:SpawnPetAt(x, y, z, "old_shadowwaxwell")

        if shadowmax ~= nil then
            inst.components.fueled:DoDelta(SpellCost(TUNING.WAXWELLJOURNAL_SPELL_COST.SHADOW_PILLARS * 2), doer)
            shadowmax:DoTaskInTime(0, function(shadowmax) shadowmax.sg:GoToState("jumpout") end)
            doer.components.health:DoDelta(-TUNING.DSTU.SHADOWWAXWELL_HEALTH_COST)
            doer.components.sanity:RecalculatePenalty()
            doer.SoundEmitter:PlaySound("dontstarve/maxwell/shadowmax_appear")
        end
        local x1, y1, z1 = doer.Transform:GetWorldPosition()
        SpawnPrefab("statue_transition").Transform:SetPosition(x1, y1, z1)
        return true
    end
end

local function ShadowPactArmorFn(inst, doer)
    if inst.components.fueled:IsEmpty() then
        return false, "NO_FUEL"
    else
        inst.components.fueled:DoDelta(SpellCost(TUNING.WAXWELLJOURNAL_SPELL_COST.SHADOW_PILLARS * 2), doer)
        doer.sg:GoToState("pact_armor_craft")
        doer.components.inventory:Equip(SpawnPrefab("pact_armor_sanity"))
        return true
    end
end

local function ShadowPactSwordFn(inst, doer)
    if inst.components.fueled:IsEmpty() then
        return false, "NO_FUEL"
    else
        inst.components.fueled:DoDelta(SpellCost(TUNING.WAXWELLJOURNAL_SPELL_COST.SHADOW_PILLARS * 2), doer)
        doer.sg:GoToState("pact_sword_craft")
        doer.components.inventory:Equip(SpawnPrefab("pact_sword_sanity"))
        return true
    end
end

local UMSPELLS = {
    ["shadow_mimic"] = {
        onselect = function(inst)
            inst.components.spellbook:SetSpellName(STRINGS.SPELLS.SHADOW_MIMIC)
            if TheWorld.ismastersim then
                inst.components.aoespell:SetSpellFn(nil)
                inst.components.spellbook:SetSpellFn(ShadowMimicSpellFn)
            end
        end,
        execute = function(inst)
            local inventory = ThePlayer.replica.inventory

            if inventory ~= nil then
                inventory:CastSpellBookFromInv(inst)
            end
        end,
        label = STRINGS.SPELLS.SHADOW_MIMIC,
        atlas = "images/the_men.xml", --didn't rename because I thought it was funny.
        normal = "the_men.tex",
        widget_scale = ICON_SCALE,
        hit_radius = ICON_RADIUS,
    },
}

env.AddPrefabPostInit("waxwelljournal", function(inst)
    --if not TheWorld.ismastersim then
    --	return
    --end Commented out to see if this is causing the issue of the spell sometimes not appearing
    if TUNING.DSTU.WAXWELL ~= "off" then
        if inst.components.spellbook ~= nil then
            for k, v in pairs(UMSPELLS) do
                if not table.contains(inst.components.spellbook.items, v) then
                    table.insert(inst.components.spellbook.items, v)
                end
            end
        end
    end
	
	inst:AddComponent("tradable")
end)


local function DoEffects(pet)
    local x, y, z = pet.Transform:GetWorldPosition()

    SpawnPrefab("statue_transition_2").Transform:SetPosition(x, y, z)

    if pet.components.follower.leader ~= nil then
        local x1, y1, z1 = pet.components.follower.leader.Transform:GetWorldPosition()
        SpawnPrefab("statue_transition").Transform:SetPosition(x1, y1, z1)
    end
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

local function OnDespawnPet(inst, pet)
    if pet:HasTag("classicshadow") then
        if pet:HasTag("shadowminion") then
            DoEffects(pet)
            pet:Remove()
        elseif inst._OnDespawnPet ~= nil then
            inst:_OnDespawnPet(pet)
        end
    else
        return inst.OldOnDespawnPet(inst, pet)
    end
end

env.AddPrefabPostInit("multiplayer_portal", function(inst)
	inst:ListenForEvent("ms_newplayercharacterspawned", function(world, data)
		if data and data.player and data.player.prefab and data.player.prefab == "waxwell" then
			local x, y, z = inst.Transform:GetWorldPosition()
			SpawnPrefab("waxwell_pact_trader").Transform:SetPosition(x + 5, 0, z - 5)
		end
	end, TheWorld)
end)

env.AddPrefabPostInit("waxwell", function(inst)
    if not TheWorld.ismastersim then
        return
    end

	inst.pact_sworn = false
	
	local _OnSave = inst.OnSave
	local _OnLoad = inst.OnLoad
	
	local function OnSave(inst, data)
		data.pact_sworn = inst.pact_sworn
		if _OnSave ~= nil then
			return _OnSave(inst, data)
		end
	end
	
	local function OnLoad(inst, data)
		if data then
			if data.pact_sworn ~= nil then
				inst.pact_sworn = data.pact_sworn
					
				if inst.pact_sworn then
					inst:AddTag("codexmantrareader")
					inst:RemoveTag("magician")
					inst:RemoveTag("shadowmagic")
						
					inst:DoTaskInTime(0, function()
						inst:RemoveComponent("magician")
					end)
						
					inst.components.health:SetAbsorptionAmount(-TUNING.WATHGRITHR_ABSORPTION)
				end
			end
		end
		
		if _OnLoad ~= nil then
			return _OnLoad(inst, data)
		end
	end
	
	inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    if inst.components.petleash ~= nil then
        inst.OldSpawnPet = inst.components.petleash.onspawnfn
        inst.components.petleash:SetOnSpawnFn(OnSpawnPet)

        inst.OldOnDespawnPet = inst.components.petleash.ondespawnfn
        inst.components.petleash:SetOnDespawnFn(OnDespawnPet)
    end

    if TUNING.DSTU.MAX_HEALTH_WELL then
        inst:ListenForEvent("attacked", CalculateMaxHealthLoss)
    end
end)