local assets =
{
    Asset("ANIM", "anim/spider_crabbit.zip"),
}
local brain = require("brains/spider_crabbitbrain")
local COLLISION_RADIUS_ON_OCEAN = 1.5
local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeCharacterPhysics(inst, 1000, COLLISION_RADIUS_ON_OCEAN)
    --RemovePhysicsColliders(inst)
    --inst.Physics:SetCollisionGroup(COLLISION.SANITY)
    --inst.Physics:CollidesWith(COLLISION.SANITY)

    inst.Transform:SetFourFaced()



    inst.AnimState:SetBank("spider_crabbit")
    inst.AnimState:SetBuild("spider_crabbit")
    inst.AnimState:PlayAnimation("idle", true)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    --[[inst.persists = false

    inst._should_teleport_time = GetTime()
    -- inst._current_boat = nil

    -- these are cached so that they can be accessed from the stategraph
    inst._attach_to_boat_fn = AttachToBoat
    inst._detach_from_boat_fn = DetachFromBoat

    -- inst._block_teleport_on_hit_task = nil]]

    inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
    inst.components.locomotor.pathcaps = { allowocean = true, ignoreLand = true }
    inst.components.locomotor.walkspeed = TUNING.OCEANHORROR.SPEED
    inst.sounds = sounds
    inst:SetStateGraph("SGspider_crabbit")

    inst:SetBrain(brain)

    --[[inst:AddComponent("sanityaura")
    inst.components.sanityaura.aurafn = CalcSanityAura]]

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.OCEANHORROR.HEALTH)
	
	inst:AddComponent("knownlocations")
	--[[
    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(TUNING.OCEANHORROR.DAMAGE)
    inst.components.combat:SetAttackPeriod(TUNING.OCEANHORROR.ATTACK_PERIOD)
    inst.components.combat:SetRetargetFunction(3, retargetfn)
    inst.components.combat.onkilledbyother = onkilledbyother
    inst.components.combat:SetRange(TUNING.OCEANHORROR.ATTACK_RANGE)


    inst:ListenForEvent("attacked", OnAttacked)
    inst:ListenForEvent("newcombattarget", OnNewCombatTarget)
    inst:ListenForEvent("death", OnDeath)

    inst:ListenForEvent("onattackother", OnAttackOther)

    inst._update_task = inst:DoPeriodicTask(FRAMES, update)


    inst:ListenForEvent("onremove", OnRemove)]]

    return inst
end

return Prefab("spider_crabbit", fn, assets)