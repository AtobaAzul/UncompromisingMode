local assets =
{
    Asset("ANIM", "anim/squid.zip"),
    Asset("ANIM", "anim/squid_water.zip"),
    Asset("ANIM", "anim/squid_build.zip"),
}

local inkassets = 
{
    Asset("ANIM","anim/squid_inked.zip"),
}

local prefabs =
{
}

local brain = require("brains/swilsonbrain")
local easing = require("easing")

local sounds =
{
    attack = "hookline/creatures/squid/attack",
    bite = "hookline/creatures/squid/gobble",
    taunt = "hookline/creatures/squid/taunt",
    death = "hookline/creatures/squid/death",
    sleep = "hookline/creatures/squid/sleep",
    hurt = "hookline/creatures/squid/hit",
    gobble = "hookline/creatures/squid/gobble",
    spit = "hookline/creatures/squid/spit",
    swim = "turnoftides/common/together/water/swim/medium",
}

local function retargetfn(inst)
    return nil
end

local RETARGET_CANT_TAGS = { "shadow" }
local function retargetfn(inst)
    return FindEntity(
                inst,
                TUNING.HOUND_TARGET_DIST,
                function(guy)
                    return inst.components.combat:CanTarget(guy)
                end,
                nil,
                RETARGET_CANT_TAGS
            )
        or nil
end

local function KeepTarget(inst, target)
    return inst:IsNear(target, TUNING.SQUID_TARGET_KEEP)
end

local function fncommon()

    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()

    MakeCharacterPhysics(inst, 10, .5)

    inst.DynamicShadow:SetSize(2.5, 1.5)
    inst.Transform:SetSixFaced()

    inst:AddTag("scarytooceanprey")
    inst:AddTag("monster")
    inst:AddTag("squid")
    inst:AddTag("herdmember")
    inst:AddTag("likewateroffducksback")

    inst.AnimState:SetBank("squiderp")
    inst.AnimState:SetBuild("graspingfear")
    inst.AnimState:PlayAnimation("idle")

    inst:AddComponent("spawnfader")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.sounds = sounds

    inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
    inst.components.locomotor.runspeed = TUNING.SQUID_RUNSPEED
    inst.components.locomotor.walkspeed = TUNING.SQUID_WALKSPEED
    inst.components.locomotor.skipHoldWhenFarFromHome = true

    inst:SetStateGraph("SGgraspingfear")
    inst:SetBrain(brain)

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.SQUID_HEALTH)

    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aura = -TUNING.SANITYAURA_MED

    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(TUNING.SQUID_DAMAGE)
    inst.components.combat:SetAttackPeriod(TUNING.SQUID_ATTACK_PERIOD)
    inst.components.combat:SetRetargetFunction(3, retargetfn)
    inst.components.combat:SetKeepTargetFunction(KeepTarget)

    inst:AddComponent("inspectable")

    inst:AddComponent("knownlocations")
    
    inst:AddComponent("timer")

    return inst
end

return Prefab("graspingfear", fncommon, assets, prefabs)
