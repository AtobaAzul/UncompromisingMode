local assets =
{
    Asset("ANIM", "anim/eyeofterror_mini_red.zip"),
    Asset("ANIM", "anim/eyeofterror_mini_green.zip"),
}

local prefabs = nil

local creature_sounds =
{
    hit = "terraria1/mini_eyeofterror/hit",
    death = "terraria1/mini_eyeofterror/death",
}

local minieyebrain = require("brains/oculet_petsbrain")


local function OnAttacked(inst, data)
    if data.attacker ~= nil and not data.attacker:HasTag("eyeofterror") then
        inst.components.combat:SetTarget(data.attacker)
    end
	
	
	if inst.summoner ~= nil and data.damage ~= nil then
		inst.summoner.components.finiteuses:Use(data.damage)
	end
end

local DIET = { FOODTYPE.MEAT }
local function commonfn(build)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()

    MakeFlyingCharacterPhysics(inst, 1, .5)

    inst.DynamicShadow:SetSize(.8, .5)
    inst.Transform:SetSixFaced()

    inst:AddTag("oculetpet")
    inst:AddTag("eyeofterror")
    inst:AddTag("flying")
    inst:AddTag("hostile")
    inst:AddTag("ignorewalkableplatformdrowning")
    inst:AddTag("monster")
    inst:AddTag("smallcreature")

    inst.AnimState:SetBank("eyeofterror_mini")
    inst.AnimState:SetBuild(build)
    inst.AnimState:PlayAnimation("idle", true)
    inst.AnimState:SetRayTestOnBB(true)

    MakeInventoryFloatable(inst, "med", 0.1, 0.75)

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    ---------------------
    inst:AddComponent("locomotor")
    inst.components.locomotor.walkspeed = 4
    inst.components.locomotor:EnableGroundSpeedMultiplier(false)
    inst.components.locomotor:SetTriggersCreep(false)

    ---------------------
    inst:AddComponent("lootdropper")

    ------------------
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.EYEOFTERROR_MINI_HEALTH)

    ------------------
    inst:AddComponent("combat")
    inst.components.combat:SetRange(TUNING.EYEOFTERROR_MINI_ATTACK_RANGE, TUNING.EYEOFTERROR_MINI_HIT_RANGE)
    inst.components.combat.hiteffectsymbol = "glomling_body"
    inst.components.combat:SetDefaultDamage(TUNING.EYEOFTERROR_MINI_DAMAGE)
    inst.components.combat:SetAttackPeriod(TUNING.EYEOFTERROR_MINI_ATTACK_PERIOD)
    inst.components.combat:SetHurtSound(creature_sounds.hit)

    ------------------
    inst:AddComponent("inspectable")
	
	inst:AddComponent("follower")

    ------------------
    MakeSmallBurnableCharacter(inst, "glomling_body")
    MakeTinyFreezableCharacter(inst, "glomling_body")

    ------------------
    inst:SetStateGraph("SGoculet_pets")
    inst:SetBrain(minieyebrain)
    inst.sounds = creature_sounds

    inst:ListenForEvent("attacked", OnAttacked)

    return inst
end

local function fnrez()
    local inst = commonfn("eyeofterror_mini_red")

    if not TheWorld.ismastersim then
        return inst
    end

    return inst
end

local function fnspaz()
    local inst = commonfn("eyeofterror_mini_green")

    if not TheWorld.ismastersim then
        return inst
    end

    return inst
end

return Prefab("oculet_rez", fnrez, assets, prefabs),
		Prefab("oculet_spaz", fnspaz, assets, prefabs)
