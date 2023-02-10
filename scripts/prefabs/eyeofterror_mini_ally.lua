local creature_sounds =
{
    hit = "terraria1/mini_eyeofterror/hit",
    death = "terraria1/mini_eyeofterror/death",
}

local minieyebrain = require("brains/eyeofterrormini_allybrain")

local function FocusTarget(inst, target)

end

local function OnWake(inst)
end

local function OnSleep(inst)
end

local KEEPTARGET_DIST = 30
local function KeepTarget(inst, target)
    return (inst.components.combat:CanTarget(target) and inst:IsNear(target, KEEPTARGET_DIST))
end

local function OnAttacked(inst, data)
    if data and data.attacker then
        inst.components.combat:SetTarget(data.attacker)
    end
end

local function onnear(inst, target)
    if inst.components.follower.leader == nil then
        target.components.leader:AddFollower(inst)
    end
end
local easing = require("easing")

local function OnDeath(inst, data)
    if inst.components.health.maxhealth < 100 then
        return
    end

    local x, y, z = inst.Transform:GetWorldPosition()
    local projectile = SpawnPrefab("eyeofterror_mini_projectile_ally")
    --projectile
    projectile.Transform:SetPosition(x, y, z)
    projectile.is_revive = true
    local pt = inst:GetPosition()
    pt.x = pt.x + math.random( -3, 3)
    pt.z = pt.z + math.random( -3, 3)
    local speed = easing.linear(3, 7, 3, 10)
    projectile:AddTag("canthit")
    projectile:AddTag("friendly")
    projectile.health = inst.components.health.maxhealth / 2
    --projectile.components.wateryprotection.addwetness = TUNING.WATERBALLOON_ADD_WETNESS/2
    projectile.components.complexprojectile:SetHorizontalSpeed(speed + math.random(4, 9))

    if TheWorld.Map:IsAboveGroundAtPoint(pt.x, 0, pt.z) or TheWorld.Map:GetPlatformAtPoint(pt.x, pt.z) ~= nil then
        inst.count = 0
        projectile.components.complexprojectile:Launch(pt, inst, inst)
    else
        if inst.count ~= nil and inst.count < 10 then
            inst.count = inst.count + 1
            inst:DoTaskInTime(0, OnDeath)
        end
        projectile:Remove()
    end
end

local DIET = { FOODTYPE.MEAT }
local function commonfn(build, tags)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()

    MakeFlyingCharacterPhysics(inst, 1, .5)

    inst.DynamicShadow:SetSize(.8, .5)
    inst.Transform:SetSixFaced()

    --inst:AddTag("eyeofterror")
    inst:AddTag("flying")
    --inst:AddTag("hostile")
    inst:AddTag("ignorewalkableplatformdrowning")
    inst:AddTag("monster")
    inst:AddTag("smallcreature")
    inst:AddTag("companion")

    inst.AnimState:SetBank("eyeofterror_mini")
    inst.AnimState:SetBuild("eyeofterror_mini_mob_build")
    inst.AnimState:PlayAnimation("idle", true)
    inst.AnimState:SetRayTestOnBB(true)

    MakeInventoryFloatable(inst, "med", 0.1, 0.75)

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end
    inst.Transform:SetScale(1.2, 1.2, 1.2)
    ---------------------
    inst:AddComponent("locomotor")
    inst.components.locomotor.walkspeed = 4
    inst.components.locomotor:EnableGroundSpeedMultiplier(false)
    inst.components.locomotor:SetTriggersCreep(false)

    ---------------------
    inst:AddComponent("lootdropper")

    ------------------
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(600)

    inst:ListenForEvent("death", OnDeath)

    ------------------
    inst:AddComponent("combat")
    inst.components.combat:SetRange(TUNING.EYEOFTERROR_MINI_ATTACK_RANGE, TUNING.EYEOFTERROR_MINI_HIT_RANGE)
    inst.components.combat.hiteffectsymbol = "glomling_body"
    inst.components.combat:SetDefaultDamage(50)
    inst.components.combat:SetAttackPeriod(TUNING.EYEOFTERROR_MINI_ATTACK_PERIOD)
    --inst.components.combat:SetRetargetFunction(2, Retarget)
    inst.components.combat:SetKeepTargetFunction(KeepTarget)
    inst.components.combat:SetHurtSound(creature_sounds.hit)

    ------------------
    inst:AddComponent("sleeper")

    ------------------
    inst:AddComponent("knownlocations")
    inst:AddComponent("follower")

    ------------------
    inst:AddComponent("inspectable")

    ------------------
    inst:AddComponent("playerprox")
    inst.components.playerprox:SetDist(4, 6) --set specific values
    inst.components.playerprox:SetOnPlayerNear(onnear)
    inst.components.playerprox:SetPlayerAliveMode(inst.components.playerprox.AliveModes.AliveOnly)

    ------------------
    MakeSmallBurnableCharacter(inst, "glomling_body")
    MakeTinyFreezableCharacter(inst, "glomling_body")

    ------------------
    MakeHauntable(inst)
    inst.components.hauntable.panicable = true

    ------------------
    inst:SetStateGraph("SGeyeofterror_mini")
    inst:SetBrain(minieyebrain)
    inst.sounds = creature_sounds

    inst:ListenForEvent("attacked", OnAttacked)

    inst.FocusTarget = FocusTarget

    inst.OnEntityWake = OnWake
    inst.OnEntitySleep = OnSleep

    return inst
end

return Prefab("eyeofterror_mini_ally", commonfn)
