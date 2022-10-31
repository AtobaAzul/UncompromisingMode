local function on_mini_eye_landed(inst)
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

return Prefab("eyeofterror_mini_projectile_ally", fn)
