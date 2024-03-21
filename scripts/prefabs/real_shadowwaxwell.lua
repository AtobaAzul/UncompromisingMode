require "brains/real_shadowwaxwellbrain"
require "stategraphs/SGreal_shadowwaxwell"

local assets = 
{
    Asset("ANIM", "anim/waxwell_shadow_mod.zip"),
	Asset("SOUND", "sound/maxwell.fsb"),
	Asset("ANIM", "anim/swap_pickaxe.zip"),
	Asset("ANIM", "anim/swap_axe.zip"),
	Asset("ANIM", "anim/swap_nightmaresword.zip"),
}

local prefabs = 
{

}

local items =
{
	AXE = "swap_axe",
	PICK = "swap_pickaxe",
    SWORD = "swap_nightmaresword"
}

local function EquipItem(inst, item)
	if item then
	    inst.AnimState:OverrideSymbol("swap_object", item, item)
	    inst.AnimState:Show("ARM_carry") 
	    inst.AnimState:Hide("ARM_normal")
	end
end

local function OnAttacked(inst, data)
    if data.attacker ~= nil then
        if data.attacker.components.petleash ~= nil and
            data.attacker.components.petleash:IsPet(inst) then
            if inst.components.lootdropper == nil then
                inst:AddComponent("lootdropper")
            end
            inst.components.lootdropper:SpawnLootPrefab("nightmarefuel", inst:GetPosition())
            data.attacker.components.petleash:DespawnPet(inst)
        --[[elseif data.attacker.components.combat ~= nil then
            inst.components.combat:SuggestTarget(data.attacker)]]
        end
    end
end

local function die(inst)
	inst.components.health:Kill()
end

local function resume(inst, time)
    if inst.death then
        inst.death:Cancel()
        inst.death = nil
    end
    inst.death = inst:DoTaskInTime(time, die)
end
--[[
local function onsave(inst, data)
	if inst.leader ~= nil then
		data.leader = inst.leader
	end
end
]]
local function KeepTarget(isnt, target)
    return target and target:IsValid() and not target:HasTag("shadowminion") and not target:HasTag("classicshadow")
end
--[[
local function onload(inst, data)
	if data.leader then
		inst.leader = data.leader
	end
end
]]
local function entitydeathfn(inst, data)
    if data.inst:HasTag("player") then
        inst:DoTaskInTime(math.random(), function() inst.components.health:Kill() end)
    end
end

local function nodebrisdmg(inst, amount, overtime, cause, ignore_invincible, afflicter, ignore_absorb)
    return afflicter ~= nil and afflicter:HasTag("quakedebris")
end

local function fn()
	local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

	inst.Transform:SetFourFaced(inst)

	MakeGhostPhysics(inst, 1, .5)

	inst.AnimState:SetBank("wilson")
	inst.AnimState:SetBuild("waxwell_shadow_mod")
	inst.AnimState:PlayAnimation("idle")
    inst.AnimState:SetMultColour(0, 0, 0, .5)
	inst.AnimState:UsePointFiltering(true)

    inst.AnimState:Hide("ARM_carry")
    inst.AnimState:Hide("hat")
    inst.AnimState:Hide("hat_hair")

    inst:AddTag("scarytoprey")
    inst:AddTag("NOBLOCK")
    inst:AddTag("classicshadow")
    --inst:AddTag("NOCLICK")

    inst.entity:SetPristine()

    inst:SetPrefabNameOverride("shadowwaxwell")
		
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("skinner")
    inst.components.skinner:SetupNonPlayerData()

	inst:AddComponent("locomotor")
    inst.components.locomotor.runspeed = TUNING.SHADOWWAXWELL_SPEED
	inst.components.locomotor:SetTriggersCreep(false)
    inst.components.locomotor.pathcaps = { ignorecreep = true }
    inst.components.locomotor:SetSlowMultiplier(.6)

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.SHADOWWAXWELL_LIFE)
    inst.components.health:StartRegen(TUNING.CHESTER_HEALTH_REGEN_AMOUNT / 4, TUNING.CHESTER_HEALTH_REGEN_PERIOD)
    inst.components.health.nofadeout = true
    inst.components.health.fire_damage_scale = TUNING.WILLOW_FIRE_DAMAGE
    inst.components.health.redirect = nodebrisdmg

    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "torso"
    -- inst.components.combat:SetRetargetFunction(1, Retarget)
    inst.components.combat:SetKeepTargetFunction(KeepTarget)
    inst.components.combat:SetAttackPeriod(TUNING.SHADOWWAXWELL_ATTACK_PERIOD)
    inst.components.combat:SetRange(2, 3)
    inst.components.combat:SetDefaultDamage(TUNING.SHADOWWAXWELL_DAMAGE)

	inst:AddComponent("inventory")
    inst.components.inventory.dropondeath = false

    inst:AddComponent("sanityaura")
    inst.components.sanityaura.penalty = TUNING.OLD_SHADOWWAXWELL_SANITY_PENALTY

    inst.items = items
    inst.equipfn = EquipItem

    EquipItem(inst)

    --inst:ListenForEvent("entity_death", function(world, data) entitydeathfn(inst, data) end, TheWorld)

    inst:AddComponent("follower")
    inst.components.follower:KeepLeaderOnAttacked()
    inst.components.follower.keepdeadleader = true
    inst.components.follower.keepleaderduringminigame = true
	
    inst:ListenForEvent("attacked", OnAttacked)

	local brain = require"brains/real_shadowwaxwellbrain"
	inst:SetBrain(brain)
	inst:SetStateGraph("SGreal_shadowwaxwell")
	
	return inst
end

return Prefab("real_shadowwaxwell", fn, assets, prefabs)