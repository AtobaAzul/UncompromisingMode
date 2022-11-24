local function spawn_eye(inst)
    local minieye = SpawnPrefab("eyeofterror_mini_ally")
    local mx, my, mz = inst.Transform:GetWorldPosition()
    minieye.Transform:SetPosition(mx, my, mz)
    minieye.sg:GoToState("appear")
    minieye:PushEvent("on_landed")
    if inst.player then
        inst.player.components.leader:AddFollower(minieye)
    end
    inst:Remove()
end

local function on_mini_eye_landed(inst)
    if inst.is_revive then
        local grounded = SpawnPrefab("eyeofterror_mini_grounded_ally")
        grounded.Transform:SetPosition(inst.Transform:GetWorldPosition())

        grounded.AnimState:PlayAnimation("land_pre", false)
        grounded.AnimState:PushAnimation("land_idle", true)

        grounded:PushEvent("on_landed")

        inst:Remove()
    else
        spawn_eye(inst)
    end
end

local function on_grounded_hit(inst, attacker)
    if not inst.components.health:IsDead() then
        inst.SoundEmitter:PlaySound("terraria1/mini_eyeofterror/egg_hit")

        inst.AnimState:PlayAnimation("land_hit")
        inst.AnimState:PushAnimation("land_idle", true)
    end
end

local function on_grounded_killed(inst)
    if inst._hatch_task ~= nil then
        inst._hatch_task:Cancel()
        inst._hatch_task = nil
    end

    inst.AnimState:PlayAnimation("land_break")
    inst.SoundEmitter:PlaySound("terraria1/mini_eyeofterror/egg_crack")
end

local function try_to_hatch(inst)
    local minieye = SpawnPrefab("eyeofterror_mini_ally")
    local mx, my, mz = inst.Transform:GetWorldPosition()
    minieye.Transform:SetPosition(mx, my, mz)
    minieye.sg:GoToState("appear")
    minieye:PushEvent("on_landed")

    -- The spawned mob inherits the helth value of the grounded "egg" when it spawns.
    minieye.components.health:SetCurrentHealth(inst.components.health.currenthealth)

    inst:Remove()
end

local EYE_LAUNCH_OFFSET = Vector3(0, 0, 0)
local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.entity:AddPhysics()
    inst.Physics:SetMass(1)
    inst.Physics:SetFriction(0)
    inst.Physics:SetDamping(0)
    inst.Physics:SetCollisionGroup(COLLISION.CHARACTERS)
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.GROUND)
    inst.Physics:SetCapsule(0.2, 0.2)
    inst.Physics:SetDontRemoveOnSleep(true)

    inst:AddTag("NOCLICK")
    inst:AddTag("projectile")

    inst.AnimState:SetBank("eyeofterror_mini")
    inst.AnimState:SetBuild("eyeofterror_mini_mob_build")
    inst.AnimState:PlayAnimation("spin_loop", true)
    inst.AnimState:SetRayTestOnBB(true)

    if not TheNet:IsDedicated() then
        inst:AddComponent("groundshadowhandler")
        inst.components.groundshadowhandler:SetSize(1.5, 0.75)
    end

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false

    ---------------------
    inst:AddComponent("locomotor")
    inst.components.locomotor:EnableGroundSpeedMultiplier(false)
    inst.components.locomotor:SetTriggersCreep(false)

    ---------------------
    inst:AddComponent("complexprojectile")
    inst.components.complexprojectile:SetGravity(-35)
    inst.components.complexprojectile:SetHorizontalSpeed(15)
    inst.components.complexprojectile:SetLaunchOffset(EYE_LAUNCH_OFFSET)
    inst.components.complexprojectile:SetOnHit(on_mini_eye_landed)

    --------------------

    return inst
end

local function groundfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("eyeofterror_mini")
    inst.AnimState:SetBuild("eyeofterror_mini_mob_build")
    inst.AnimState:PlayAnimation("land_idle", true)

    MakeInventoryFloatable(inst, "med", 0.1, 0.75)

    inst:AddTag("eyeofterror")
    inst:AddTag("smallcreature")

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false

    ---------------------
    inst:AddComponent("inspectable")

    ---------------------
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.EYEOFTERROR_MINI_HEALTH)

    ---------------------
    inst:AddComponent("combat")
    inst.components.combat:SetOnHit(on_grounded_hit)

    ---------------------
    inst:ListenForEvent("death", on_grounded_killed)

    ---------------------
    inst._hatch_task = inst:DoTaskInTime(TUNING.EYEOFTERROR_MINI_EGGTIME, try_to_hatch)

    return inst
end

return Prefab("eyeofterror_mini_projectile_ally", fn),
    Prefab("eyeofterror_mini_grounded_ally", groundfn)
