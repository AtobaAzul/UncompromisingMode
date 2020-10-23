local assets =
{
    Asset("ANIM", "anim/mossling_build.zip"),
    Asset("ANIM", "anim/mossling_basic.zip"),
    Asset("ANIM", "anim/mossling_actions.zip"),
    Asset("ANIM", "anim/mossling_angry_build.zip"),
    Asset("ANIM", "anim/mossling_yule_build.zip"),
    Asset("ANIM", "anim/mossling_yule_angry_build.zip"),
    -- Asset("SOUND", "sound/mossling.fsb"),
}

local prefabs =
{
    "mossling_spin_fx",
    "goose_feather",
    "drumstick",
}

local brain = require("brains/mushdrake_redbrain")

SetSharedLootTable( 'mushdrake_red',
{
    {'meat',             1.00},
    {'drumstick',        1.00},
    {'goose_feather',    1.00},
    {'goose_feather',    1.00},
    {'goose_feather',    0.33},
})

local LOSE_TARGET_DIST = 13
local TARGET_DIST = 6



local RETARGET_CANT_TAGS = { "mushdrake", "smallcreature", "mossling", "moose" }
local RETARGET_ONEOF_TAGS = { "monster", "player" }
local function RetargetFn(inst)
    return 
         FindEntity(
                inst,
                TARGET_DIST,
                function(guy)
                    return inst.components.combat:CanTarget(guy)
                end,
                nil,
                RETARGET_CANT_TAGS,
                RETARGET_ONEOF_TAGS
            )
end

local function KeepTargetFn(inst, target)
    return inst.components.combat:CanTarget(target)
or not inst:IsNear(target, LOSE_TARGET_DIST)
end

local function OnAttacked(inst, data)
    inst.components.combat:SetTarget(data.attacker)
    inst.components.combat:ShareTarget(data.attacker, 60,
        function(guy)
guy:HasTag("mushdrake")
end,
    60)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()

    inst.Transform:SetFourFaced()

    inst.DynamicShadow:SetSize(1.5, 1.25)

    MakeCharacterPhysics(inst, 50, .5)

    inst.AnimState:SetBank("mushdrake_red")
    inst.AnimState:SetBuild("mushdrake_red")
    inst.AnimState:PlayAnimation("idle", true)

    ------------------------------------------

    inst:AddTag("mushdrake")
    inst:AddTag("animal")

    --herdmember (from herdmember component) added to pristine state for optimization
    inst:AddTag("herdmember")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    ------------------

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.MOSSLING_HEALTH)
    inst.components.health.destroytime = 5

    ------------------

    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(TUNING.MOSSLING_DAMAGE)
    inst.components.combat.playerdamagepercent = .5
    inst.components.combat:SetRange(TUNING.MOSSLING_ATTACK_RANGE*3,TUNING.MOSSLING_ATTACK_RANGE)
    inst.components.combat.hiteffectsymbol = "mossling_body"
    inst.components.combat:SetAttackPeriod(TUNING.MOSSLING_ATTACK_PERIOD)
    inst.components.combat:SetRetargetFunction(1.5, RetargetFn)
    inst.components.combat:SetKeepTargetFunction(KeepTargetFn)
    inst.components.combat:SetHurtSound("dontstarve_DLC001/creatures/mossling/hurt")

    ------------------------------------------

    inst:AddComponent("sizetweener")
	inst.components.sizetweener:StartTween(1.55, 2)
    ------------------------------------------

    --inst:AddComponent("sleeper")
    --inst.components.sleeper:SetResistance(4)

    ------------------------------------------

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetChanceLootTable('mushdrake_red')

    ------------------------------------------

    inst:AddComponent("inspectable")
    inst.components.inspectable:RecordViews()

    ------------------------------------------

    inst:AddComponent("knownlocations")

    ------------------------------------------

    ------------------------------------------

    inst:ListenForEvent("attacked", OnAttacked)

    ------------------------------------------

    MakeMediumBurnableCharacter(inst, "swap_fire")
    MakeHugeFreezableCharacter(inst, "mossling_body")

    ------------------------------------------

    inst:AddComponent("locomotor")
    inst.components.locomotor.walkspeed = TUNING.MOOSE_WALK_SPEED/3

    inst:SetStateGraph("SGmushdrake_red")
    inst:SetBrain(brain)

    MakeHauntablePanic(inst)

    return inst
end

return Prefab("mushdrake_red", fn, assets, prefabs)
