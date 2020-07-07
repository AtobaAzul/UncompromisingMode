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

local brain = require("brains/stumplingbrain")
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

SetSharedLootTable('squid',
{
    {'twigs', 2.000},
})

local WAKE_TO_FOLLOW_DISTANCE = 8
local SLEEP_NEAR_HOME_DISTANCE = 10
local SHARE_TARGET_DIST = 30
local HOME_TELEPORT_DIST = 30

local NO_TAGS = { "FX", "NOCLICK", "DECOR", "INLIMBO" }

--Called from stategraph
local function LaunchProjectile(inst, targetpos)
   -- local x, y, z = inst.Transform:GetWorldPosition()

   -- local projectile = SpawnPrefab("inksplat")
   -- projectile.Transform:SetPosition(x, y, z)

    --V2C: scale the launch speed based on distance
    --     because 15 does not reach our max range.
   -- local dx = targetpos.x - x
   -- local dz = targetpos.z - z
   -- local rangesq = dx * dx + dz * dz
    --local maxrange = TUNING.FIRE_DETECTOR_RANGE
    --local speed = easing.linear(rangesq, 15, 3, maxrange * maxrange)
   -- local speed = easing.linear(rangesq, 15, 1, maxrange * maxrange)
   -- projectile.components.complexprojectile:SetHorizontalSpeed(speed)
   -- projectile.components.complexprojectile:Launch(targetpos, inst, inst)
end

local function ShouldWakeUp(inst)
    return DefaultWakeTest(inst) or (inst.components.follower and inst.components.follower.leader and not inst.components.follower:IsNearLeader(WAKE_TO_FOLLOW_DISTANCE))
end

local function ShouldSleep(inst)
    -- this will always return false at the momnent, until we decide how they should naturally sleep. 
    return false
        and not (inst.components.combat and inst.components.combat.target)
        and not (inst.components.burnable and inst.components.burnable:IsBurning())
        and (not inst.components.homeseeker or inst:IsNear(inst.components.homeseeker.home, SLEEP_NEAR_HOME_DISTANCE))
end

local function OnNewTarget(inst, data)
    --if inst.components.sleeper:IsAsleep() then
        --inst.components.sleeper:WakeUp()
    --end
end

local function retargetfn(inst)

    return nil
end

local function KeepTarget(inst, target)
    return inst:IsNear(target, TUNING.SQUID_TARGET_KEEP)
end


local function OnAttacked(inst, data)
    inst.components.combat:SetTarget(data.attacker)
    inst.components.combat:ShareTarget(data.attacker, SHARE_TARGET_DIST,
        function(dude)
            return not (dude.components.health ~= nil and dude.components.health:IsDead())
                and (dude:HasTag("squid"))
                and data.attacker ~= (dude.components.follower ~= nil and dude.components.follower.leader or nil)
        end, 5)
end

local function OnAttackOther(inst, data)
    inst.components.combat:ShareTarget(data.target, SHARE_TARGET_DIST,
        function(dude)
            return not (dude.components.health ~= nil and dude.components.health:IsDead())
                and (dude:HasTag("squid"))
                and data.target ~= (dude.components.follower ~= nil and dude.components.follower.leader or nil)
        end, 5)
end



local function OnEntitySleep(inst)
end

local function OnSave(inst, data)

end

local function OnLoad(inst, data)

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
    inst:AddTag("likewateroffducksback")

    inst.AnimState:SetBank("stumpling")--"stumpling")--"squiderp")
    inst.AnimState:SetBuild("stumpling")
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

    inst:SetStateGraph("SGstumpling")

	inst:AddComponent("embarker")
	inst.components.embarker.embark_speed = inst.components.locomotor.runspeed

    inst.components.locomotor:SetAllowPlatformHopping(true)

	


    inst:SetBrain(brain)

    inst:AddComponent("follower")
    inst:AddComponent("entitytracker")

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.SQUID_HEALTH)

    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aura = -TUNING.SANITYAURA_MED

    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(TUNING.SQUID_DAMAGE)
    inst.components.combat:SetAttackPeriod(TUNING.SQUID_ATTACK_PERIOD)
    inst.components.combat:SetRetargetFunction(3, retargetfn)
    inst.components.combat:SetKeepTargetFunction(KeepTarget)
    inst.components.combat:SetHurtSound(inst.sounds.hurt)
    inst.components.combat:SetRange(TUNING.SQUID_TARGET_RANGE, TUNING.SQUID_ATTACK_RANGE)
    inst.components.combat:EnableAreaDamage(true)
    inst.components.combat:SetAreaDamage(TUNING.SQUID_ATTACK_RANGE, 1, function(ent, inst) 
        if not ent:HasTag("squid") then
            return true
        else  
            if ent:IsValid() then   
                ent.SoundEmitter:PlaySound("hookline/creatures/squid/slap")         
                local x,y,z = ent.Transform:GetWorldPosition()
                local angle = inst:GetAngleToPoint(x,y,z) 
                ent.Transform:SetRotation(angle)
                ent.sg:GoToState("fling")
            end
        end
    end)

    inst.components.combat.battlecryenabled = false

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetChanceLootTable('squid')

    inst:AddComponent("inspectable")


    --inst:AddComponent("sleeper")
    --inst.components.sleeper:SetResistance(3)
    --inst.components.sleeper.testperiod = GetRandomWithVariance(6, 2)
    --inst.components.sleeper:SetSleepTest(ShouldSleep)
    --inst.components.sleeper:SetWakeTest(ShouldWakeUp)
    inst:ListenForEvent("newcombattarget", OnNewTarget)

    inst:AddComponent("knownlocations")
    
    inst:AddComponent("timer")



    MakeHauntablePanic(inst)
    MakeMediumFreezableCharacter(inst, "squid_body")
    MakeMediumBurnableCharacter(inst, "squid_body")

    inst.OnEntitySleep = OnEntitySleep

    inst.LaunchProjectile = LaunchProjectile
    inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    inst:ListenForEvent("attacked", OnAttacked)
    inst:ListenForEvent("onattackother", OnAttackOther)

  

    return inst
end





return Prefab("stumpling", fncommon, assets, prefabs)
