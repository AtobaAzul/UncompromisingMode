local function Turn(inst)
    inst.dir = (inst.dir - inst.angle) + math.random()
    inst.components.locomotor:RunInDirection(inst.dir)
    inst.components.locomotor:RunForward()

    inst:RemoveEventCallback("animover", Turn)
end

local function TurnAnim(inst)
    inst.reverse = math.random() > 0.5

    if inst.reverse then
        inst.angle = 90
    else
        inst.angle = -90
    end

    inst.AnimState:SetScale(1, (inst.reverse and 1 or -1) * 1)

    inst.AnimState:PlayAnimation("turn")
    inst:ListenForEvent("animover", Turn)
    inst.AnimState:PushAnimation("idle_loop")

    inst.components.locomotor:Stop()

    inst.turn_task = inst:DoTaskInTime(math.random(15, 30), TurnAnim)
end
local function DoSound(inst)
    inst.SoundEmitter:PlaySound("grotto/common/moon_alter/link/start", "horn", 0.25)

    inst.soundtask =inst:DoTaskInTime(math.random(20, 40), DoSound)
end
local SWIMMING_COLLISION_MASK = COLLISION.GROUND
    + COLLISION.LAND_OCEAN_LIMITS
    + COLLISION.OBSTACLES
    + COLLISION.SMALLOBSTACLES

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddLight()
    inst.entity:AddNetwork()
    inst.entity:AddPhysics()

    inst.Physics:SetMass(1)
    inst.Physics:SetFriction(0)
    inst.Physics:SetDamping(5)
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.LAND_OCEAN_LIMITS)
    inst.Physics:SetCapsule(0.5, 1)


    inst.AnimState:SetBank("sea_shad")
    inst.AnimState:SetBuild("sea_shadow")
    inst.AnimState:PlayAnimation("idle_loop", true)
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.Physics:SetCollisionMask(SWIMMING_COLLISION_MASK)
    inst.AnimState:SetSortOrder(ANIM_SORT_ORDER_BELOW_GROUND.UNDERWATER)
    inst.AnimState:SetLayer(LAYER_WIP_BELOW_OCEAN)
    inst.AnimState:SetMultColour(0, 0, 0, 0.125)
    inst.AnimState:UsePointFiltering(true)

    inst.SoundEmitter:PlaySound("rifts3/mutated_deerclops/twitching_LP", "sea_shadow_sound", 0.15)

    inst:AddTag("ignorewalkableplatforms")
    inst:AddTag("NOCLICK")
    inst:AddTag("NOBLOCK")
    inst:AddTag("scarytoprey")
    inst:AddTag("scarytooceanprey")

    inst.reverse = math.random() > 0.5

    inst.soundtask = inst:DoTaskInTime(math.random(20, 40), DoSound)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.angle = 90
    --inst.entity:SetCanSleep(false)


    inst.Physics:SetCollisionCallback(Turn)

    -- locomotor must be constructed before the stategraph!
    inst:AddComponent("locomotor")
    inst.components.locomotor.walkspeed = 8
    inst.components.locomotor.runspeed = 8
    inst.components.locomotor:EnableGroundSpeedMultiplier(false)
    inst.components.locomotor.pathcaps = { allowocean = true }
    inst:DoTaskInTime(0, function(inst)
        inst.SoundEmitter:PlaySound("grotto/common/moon_alter/link/start", "horn", 0.66)

        local player = inst:GetNearestPlayer(true)
        local x, y, z
        if player then
            x, y, z = player.Transform:GetWorldPosition()
        end
        inst.dir = inst:GetAngleToPoint(x, y, z)
        inst.components.locomotor:RunInDirection(inst.dir)
        inst.components.locomotor:RunForward()

        inst.turn_task = inst:DoTaskInTime(math.random(15, 30), TurnAnim)
    end)

    inst:DoTaskInTime(math.random(30, 60), function(inst)
        inst.persists = false
    end)

    inst:DoPeriodicTask(3, function(inst)
        local pt = inst:GetPosition()
        if FindWalkableOffset(pt, inst.Transform:GetRotation(), 20, 1) then
            TurnAnim(inst)
        end
    end)

    
    return inst
end

return Prefab("sea_shadow", fn)
