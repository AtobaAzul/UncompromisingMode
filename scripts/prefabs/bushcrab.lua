local assets =
{
    Asset("ANIM", "anim/ds_spider_basic.zip"),
    Asset("ANIM", "anim/bush_crab.zip"),
    Asset("SOUND", "sound/spider.fsb"),
}

local prefabs =
{
    "berries",
    "monstermeat",
    "berrybush",
}

SetSharedLootTable('bushcrab',
{
    {'dug_berrybush', 1.0},
    {'berries', 1.0},
    {'berries', 0.5},
    {'twigs', 0.5},
    {'monstermeat', 0.5},
})

local brain = require "brains/spiderbrain"

local function FindTarget(inst, radius)
    return FindEntity(
        inst,
        SpringCombatMod(radius),
        function(guy)
            return (not guy:HasTag("monster") or guy:HasTag("player"))
                and inst.components.combat:CanTarget(guy)
                and not (inst.components.follower ~= nil and inst.components.follower.leader == guy)
        end,
        { "_combat", "character" },
        { "INLIMBO" }
    )
end

local function Retarget(inst)
    return FindTarget(inst, TUNING.SPIDER_WARRIOR_TARGET_DIST)
end

local function keeptargetfn(inst, target)
    return target ~= nil
        and target.components.combat ~= nil
        and target.components.health ~= nil
        and not target.components.health:IsDead()
        and not (inst.components.follower ~= nil and
                (inst.components.follower.leader == target or inst.components.follower:IsLeaderSame(target)))
end

local function OnAttacked(inst, data)
    inst.components.combat:SetTarget(data.attacker)
    inst.components.combat:ShareTarget(data.attacker, 30, function(dude)
        return dude:HasTag("bushcrab")
            and not dude.components.health:IsDead()
            and dude.components.follower ~= nil
            and dude.components.follower.leader == inst.components.follower.leader
    end, 10)
    --[[inst.components.combat:ShareTarget(data.attacker, 30, function(dude)
        return dude:HasTag("spider")
            and not dude.components.health:IsDead()
            and dude.components.follower ~= nil
            and dude.components.follower.leader == inst.components.follower.leader
    end, 10)--]]
end
--[[
local function SanityAura(inst, observer)
    return -TUNING.SANITYAURA_SMALL
end--]]

local function BasicAwakeCheck(inst)
    return not inst.cansleep
        or (inst.components.combat ~= nil and inst.components.combat.target ~= nil)
        or (inst.components.burnable ~= nil and inst.components.burnable:IsBurning())
        or (inst.components.freezable ~= nil and inst.components.freezable:IsFrozen())
end


local function SleepTest(inst)
    if BasicAwakeCheck(inst) then
        return false
    end
end

local function WakeTest(inst)
    if BasicAwakeCheck(inst) then
        return true
    end
    local homePos = inst.components.knownlocations:GetLocation("home")
    return homePos ~= nil and inst:GetDistanceSqToPoint(homePos) >= 25--5 * 5
end

local function OnWorked(inst) 
	if inst:HasTag("hiding") and not inst.components.health:IsDead() then 
		inst:PushEvent("exitshield")
	end
end
local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddLightWatcher()
    inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()

    MakeCharacterPhysics(inst, 10, .5)

    inst.DynamicShadow:SetSize(1.5, .5)
    inst.Transform:SetFourFaced()

    ----------

    inst:AddTag("cavedweller")
    inst:AddTag("monster")
    inst:AddTag("hostile")
    inst:AddTag("scarytoprey")
    inst:AddTag("canbetrapped")
    inst:AddTag("smallcreature")
    inst:AddTag("spider")
	inst:AddTag("spider_hider")
	inst:AddTag("bushcrab")

    inst.AnimState:SetBank("spider_hider")
    inst.AnimState:SetBuild("bush_crab")
    inst.AnimState:PlayAnimation("idle")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    ----------

    -- locomotor must be constructed before the stategraph!
    inst:AddComponent("locomotor")
    inst.components.locomotor:SetSlowMultiplier( 1 )

    inst.components.locomotor.walkspeed = TUNING.SPIDER_HIDER_WALK_SPEED
    inst.components.locomotor.runspeed = TUNING.SPIDER_HIDER_RUN_SPEED

    inst:SetStateGraph("SGspider")

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetChanceLootTable('bushcrab')

    inst.components.lootdropper.numrandomloot = 1

    ---------------------
    MakeMediumBurnableCharacter(inst, "body")
    MakeMediumFreezableCharacter(inst, "body")
    inst.components.burnable.flammability = TUNING.SPIDER_FLAMMABILITY
    ---------------------

    ------------------
    inst:AddComponent("health")

    inst.components.health:SetMaxHealth(TUNING.SPIDER_HIDER_HEALTH)

    ------------------

    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(TUNING.SPIDER_HIDER_DAMAGE)
    inst.components.combat:SetAttackPeriod(TUNING.SPIDER_HIDER_ATTACK_PERIOD)
    inst.components.combat:SetRetargetFunction(1, Retarget)
    inst.components.combat.hiteffectsymbol = "body"
    inst.components.combat:SetKeepTargetFunction(keeptargetfn)
    inst.components.combat:SetHurtSound("dontstarve/creatures/cavespider/hit_response")

    inst:AddComponent("follower")
    inst.components.follower.maxfollowtime = TUNING.TOTAL_DAY_TIME

    ------------------

    inst:AddComponent("sleeper")
    inst.components.sleeper:SetResistance(2)
    inst.components.sleeper:SetSleepTest(SleepTest)
    inst.components.sleeper:SetWakeTest(WakeTest)
    ------------------

    inst:AddComponent("knownlocations")

    ------------------

    inst:AddComponent("eater")
    inst.components.eater:SetDiet({ FOODTYPE.VEGGIE }, { FOODTYPE.VEGGIE })
    inst.components.eater:SetCanEatHorrible()
    inst.components.eater.strongstomach = true -- can eat monster meat!

    ------------------

    inst:AddComponent("inspectable")

    ------------------

    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aura = -TUNING.SANITYAURA_SMALL

    MakeHauntablePanic(inst)

    inst:SetBrain(brain)

    inst:ListenForEvent("attacked", OnAttacked)
    inst:ListenForEvent("entitysleep", OnEntitySleep)
	   inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.DIG)
    inst.components.workable:SetOnFinishCallback(OnWorked)
    inst.components.workable:SetWorkLeft(0)
	inst.sg:GoToState("taunt")

    return inst
end

return Prefab("bushcrab", fn, assets, prefabs)