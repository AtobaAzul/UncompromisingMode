local assets =
{
	Asset("ANIM", "anim/frog_yellow_build.zip"),
}

local prefabs =
{
    "froglegs",
    "frogsplash",
	"sporecloud"
}

SetSharedLootTable('uncompromising_toad',
{
    --{'froglegs', 1.0},
    {'sporecloud_toad', .5},
})

local brain = require "brains/uncompromising_toadbrain"

local function retargetfn(inst)
    if not inst.components.health:IsDead() and not inst.components.sleeper:IsAsleep() then
        return FindEntity(inst, TUNING.FROG_TARGET_DIST, function(guy) 
            if not guy.components.health:IsDead() then
                return guy.components.inventory ~= nil
            end
        end,
        {"_combat","_health"}, -- see entityreplica.lua
        {"frog","toadstool","toad"} -- see entityreplica.lua
        )
    end
end

local function ShouldSleep(inst)
    return false -- frogs either go to their home, or just sit on the ground.
end

local function OnAttacked(inst, data)
    inst.components.combat:SetTarget(data.attacker)
    inst.components.combat:ShareTarget(data.attacker, 30, function(dude) return dude:HasTag("frog") and not dude.components.health:IsDead() end, 5)
end

local function OnGoingHome(inst)
    SpawnPrefab("frogsplash").Transform:SetPosition(inst.Transform:GetWorldPosition())
end

local function OnHitOther(inst, other, damage)
    inst.components.thief:StealItem(other)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()

    MakeCharacterPhysics(inst, 1, .3)

    inst.DynamicShadow:SetSize(1.5, .75)
    inst.Transform:SetFourFaced()

    inst.AnimState:SetBank("frog")
	inst.AnimState:SetBuild("frog_yellow_build")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("animal")
    inst:AddTag("prey")
    inst:AddTag("hostile")
    inst:AddTag("smallcreature")
    inst:AddTag("frog")
    inst:AddTag("canbetrapped")
	inst:AddTag("toad")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
    inst.components.locomotor.walkspeed = 6
    inst.components.locomotor.runspeed = 10

    inst:SetStateGraph("SGfrog")

    inst:SetBrain(brain)

    inst:AddComponent("sleeper")
    inst.components.sleeper:SetSleepTest(ShouldSleep)
	
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.FROG_HEALTH + 20)

    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(TUNING.FROG_DAMAGE)
    inst.components.combat:SetAttackPeriod(TUNING.FROG_ATTACK_PERIOD * 0.9)
    inst.components.combat:SetRetargetFunction(3, retargetfn)

    inst.components.combat.onhitotherfn = OnHitOther

    inst:AddComponent("thief")

    MakeTinyFreezableCharacter(inst, "frogsack")

    MakeHauntablePanic(inst)

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetChanceLootTable('uncompromising_toad')

    inst:AddComponent("knownlocations")
    inst:AddComponent("inspectable")

    inst:ListenForEvent("attacked", OnAttacked)
    inst:ListenForEvent("goinghome", OnGoingHome)

    return inst
end

return Prefab("uncompromising_toad", fn, assets, prefabs)