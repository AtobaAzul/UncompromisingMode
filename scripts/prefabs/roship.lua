local brain = require "brains/bightbrain"
local clockwork_common = require "prefabs/clockwork_common"
local easing = require("easing")

SetSharedLootTable('roship',
    {
        { 'gears',            0.5 },
        { 'nightmarefuel',    0.6 },
        { 'thulecite_pieces', 0.5 },
        { 'trinket_6',        1.00 },
        { 'trinket_6',        0.55 },
        { 'trinket_1',        0.25 },
        { 'gears',            0.25 },
        { 'redgem',           0.25 },
        { "greengem",         0.05 },
        { "yellowgem",        0.05 },
        { "purplegem",        0.05 },
        { "orangegem",        0.05 },
        { "thulecite",        0.01 },
    })

local SHARE_TARGET_DIST = 30

local function NormalRetarget(inst)
    local targetDist = 16
    if inst.components.knownlocations:GetLocation("investigate") then
        targetDist = 16
    end
    return FindEntity(inst, targetDist,
        function(guy)
            if inst.components.combat:CanTarget(guy) then
                return guy:HasTag("character") or guy:HasTag("pig")
            end
        end)
end


local function keeptargetfn(inst, target)
    return target
        and target.components.combat
        and target.components.health
        and not target.components.health:IsDead()
end

local function OnAttacked(inst, data)
    clockwork_common.OnAttacked(inst, data)
end
local function Zapp(inst, target)
    if target ~= nil then
        local x, y, z = inst.Transform:GetWorldPosition()
        local projectile = SpawnPrefab("roship_projectile")
        projectile.Transform:SetPosition(x, y, z)
        local a, b, c = target.Transform:GetWorldPosition()
        local targetpos = target:GetPosition()
        targetpos.x = targetpos.x + math.random(-1, 1)
        targetpos.z = targetpos.z + math.random(-1, 1)
        local dx = a - x
        local dz = c - z
        local rangesq = dx * dx + dz * dz
        local maxrange = 15
        local bigNum = 10
        local speed = easing.linear(rangesq, bigNum, 3, maxrange * maxrange)
        projectile:AddTag("canthit")
        projectile.components.complexprojectile:SetHorizontalSpeed(speed + math.random(4, 9))
        projectile.components.complexprojectile:Launch(targetpos, inst, inst)
    end
end
local function DoSnowballBelch(inst)
    local maxsnow = 1
    for k = 1, maxsnow do
        if inst.components.combat.target ~= nil then
            local target = inst.components.combat.target
            inst:DoTaskInTime(FRAMES + math.random() * 0.1, Zapp, target)
        end
    end
end
local function fn(Sim)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.DynamicShadow:SetSize(3, 2)
    inst.entity:AddNetwork()
    inst.entity:AddLightWatcher()

    --inst.DynamicShadow:SetSize(1, .75)
    inst.Transform:SetFourFaced()
    inst.AnimState:SetBank("roship")
    inst.AnimState:SetBuild("roship")
    inst.AnimState:PlayAnimation("idle", true)
    MakeCharacterPhysics(inst, 100, 0.5)
    --MakePoisonableCharacter(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    -- locomotor must be constructed before the stategraph!
    inst:AddComponent("locomotor")
    inst.components.locomotor.walkspeed = 2
    inst.components.locomotor.runspeed = 2


    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetChanceLootTable('roship')

    ---------------------
    --MakeMediumBurnableCharacter(inst, "torso")
    MakeMediumFreezableCharacter(inst, "rook_head")
    --inst.components.burnable.flammability = 0.33
    ---------------------


    inst:AddTag("monster")
    inst:AddTag("hostile")
    inst:AddTag("chess")
    inst:AddTag("roship")
	inst:AddTag("shadow_aligned")	

    ------------------
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(900)
    ------------------

    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "knight_spring"
    inst.components.combat:SetKeepTargetFunction(keeptargetfn)
    inst.components.combat:SetAttackPeriod(TUNING.BISHOP_ATTACK_PERIOD)
    inst.components.combat:SetRange(TUNING.BISHOP_ATTACK_DIST * 2)
    inst.components.combat:SetRetargetFunction(1, NormalRetarget)
    inst.components.combat:SetDefaultDamage(50)
    ------------------

    local acidinfusible = inst:AddComponent("acidinfusible")
    acidinfusible:SetFXLevel(2)
    acidinfusible:SetMultipliers(TUNING.ACID_INFUSION_MULT.WEAKER)

    ------------------

    inst:AddComponent("knownlocations")
    ------------------
    inst:AddComponent("sleeper")
    --inst.components.sleeper:SetWakeTest(ShouldWake)
    --inst.components.sleeper:SetSleepTest(ShouldSleep)
    inst.components.sleeper:SetResistance(3)

    ------------------
    inst.DoSnowballBelch = DoSnowballBelch
    inst:AddComponent("inspectable")

    ------------------
    inst:SetStateGraph("SGroship")
    inst:SetBrain(brain)
    inst.sg:GoToState("waken")
    inst:ListenForEvent("attacked", OnAttacked)
    return inst
end

return Prefab("roship", fn)
