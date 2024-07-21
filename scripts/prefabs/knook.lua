local brain = require "brains/bightbrain"
local assets =
{

}


local prefabs =
{

}
SetSharedLootTable('knook',
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
    inst.components.combat:SetTarget(data.attacker)
    inst.components.combat:ShareTarget(data.target, SHARE_TARGET_DIST, function(dude) return dude:HasTag("chess") and not dude.components.health:IsDead() end, 5)
end

local function fn(Sim)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.DynamicShadow:SetSize(4, 2)
    inst.entity:AddNetwork()
    inst.entity:AddLightWatcher()

    --inst.DynamicShadow:SetSize(1, .75)
    inst.Transform:SetFourFaced()
    inst.AnimState:SetBank("knook")
    inst.AnimState:SetBuild("knook")
    inst.AnimState:PlayAnimation("idle_loop", true)
    MakeCharacterPhysics(inst, 100, 0.5)
    --MakePoisonableCharacter(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    -- locomotor must be constructed before the stategraph!
    inst:AddComponent("locomotor")
    inst.components.locomotor.walkspeed = 4


    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetChanceLootTable('knook')

    ---------------------
    --MakeMediumBurnableCharacter(inst, "torso")
    MakeMediumFreezableCharacter(inst, "knight_spring")
    --inst.components.burnable.flammability = 0.33
    ---------------------


    inst:AddTag("monster")
    inst:AddTag("hostile")
    inst:AddTag("chess")
    inst:AddTag("knook")
	inst:AddTag("shadow_aligned")	

    ------------------
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(900)
    ------------------

    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "knight_spring"
    inst.components.combat:SetKeepTargetFunction(keeptargetfn)
    inst.components.combat:SetDefaultDamage(50)
    inst.components.combat:SetAttackPeriod(3)
    inst.components.combat:SetRetargetFunction(1, NormalRetarget)
    inst.components.combat:SetRange(3, 3)
    ------------------

    ------------------

    inst:AddComponent("knownlocations")
    ------------------
    inst:AddComponent("sleeper")
    --inst.components.sleeper:SetWakeTest(ShouldWake)
    --inst.components.sleeper:SetSleepTest(ShouldSleep)
    inst.components.sleeper:SetResistance(3)

    ------------------

    inst:AddComponent("inspectable")

    ------------------
    local acidinfusible = inst:AddComponent("acidinfusible")
    acidinfusible:SetFXLevel(2)
    acidinfusible:SetMultipliers(TUNING.ACID_INFUSION_MULT.WEAKER)

    ------------------

    inst:ListenForEvent("attacked", OnAttacked)
    inst:SetStateGraph("SGknook")
    inst:SetBrain(brain)
    inst.sg:GoToState("waken")

    return inst
end

return Prefab("knook", fn, assets, prefabs)
