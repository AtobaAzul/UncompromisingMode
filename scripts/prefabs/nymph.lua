local brain = require("brains/nymphbrain")

local sounds = {
    flap = "farming/creatures/lord_fruitfly/LP",
    hurt = "farming/creatures/lord_fruitfly/hit",
    attack = "farming/creatures/lord_fruitfly/attack",
    die = "farming/creatures/lord_fruitfly/die",
    die_ground = "farming/creatures/lord_fruitfly/hit",
    sleep = "farming/creatures/lord_fruitfly/sleep",
    buzz = "farming/creatures/lord_fruitfly/hit",
}


local function common()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()

    inst.DynamicShadow:SetSize(2, 0.75)
    inst.Transform:SetFourFaced()

    MakeGhostPhysics(inst, 1, 0.5)

    inst.AnimState:SetBank("fruitfly")

    inst:AddTag("flying")
    inst:AddTag("ignorewalkableplatformdrowning")

    return inst
end

local function common_server(inst)
    inst:AddComponent("inspectable")

    inst:AddComponent("sleeper")
    inst.components.sleeper:SetResistance(3)

    inst:AddComponent("locomotor")
    inst.components.locomotor.walkspeed = 6
    inst.components.locomotor.pathcaps = {allowocean = true}

    MakeMediumFreezableCharacter(inst, "fruit")

    MakeHauntablePanic(inst)

    return inst
end

local function LootSetupFunction(lootdropper)
    lootdropper.chanceloot = nil
    if not TheSim:FindFirstEntityWithTag("friendlyfruitfly") then
        lootdropper:AddChanceLoot("fruitflyfruit", 1.0)
    end
end

local function KeepTargetFn(inst, target)
    local p1x, p1y, p1z = inst.components.knownlocations:GetLocation("home"):Get()
    local p2x, p2y, p2z = target.Transform:GetWorldPosition()
    local maxdist = TUNING.LORDFRUITFLY_DEAGGRO_DIST
    return inst.components.combat:CanTarget(target) and distsq(p1x, p1z, p2x, p2z) < maxdist * maxdist
end

local RETARGET_MUSTTAGS = { "player" }
local RETARGET_CANTTAGS = { "playerghost" }
local function RetargetFn(inst)
    return not inst.planttarget and not inst.soiltarget and
        FindEntity(inst, TUNING.LORDFRUITFLY_TARGETRANGE, function(guy) return inst.components.combat:CanTarget(guy) end, RETARGET_MUSTTAGS, RETARGET_CANTTAGS) or nil
end

local function OnAttacked(inst, data)
    local attacker = data ~= nil and data.attacker or nil
    if attacker == nil then
        return
    end
    inst.components.combat:SetTarget(attacker)
end



local function ShouldSleep(inst)
    return false
end

local function ShouldWake(inst)
    return true
end


local function ShouldKeepTarget()
    return false
end

local miniassets =
{
    Asset("ANIM", "anim/fruitfly.zip"),
    Asset("ANIM", "anim/fruitfly_evil_minion.zip"),
}

local function minifn()
    local inst = common()

    inst.sounds = sounds
    
    inst.AnimState:SetBuild("nymph")
    inst.AnimState:PlayAnimation("idle")


    inst:AddTag("fruitfly")
    inst:AddTag("hostile")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    common_server(inst)
    
    inst:AddComponent("follower")

    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "fruit"
    inst.components.combat:SetKeepTargetFunction(ShouldKeepTarget)

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.FRUITFLY_HEALTH)
    
    inst.components.sleeper:SetSleepTest(ShouldSleep)
    inst.components.sleeper:SetWakeTest(ShouldWake)

    inst:AddComponent("lootdropper")

    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aura = TUNING.SANITYAURA_TINY
    inst.components.locomotor.walkspeed = 4
	inst:AddComponent("knownlocations")
    inst:SetBrain(brain)
    inst:SetStateGraph("SGfruitfly")

    inst:ListenForEvent("attacked", OnAttacked)

    return inst
end
return  Prefab("nymph", minifn)