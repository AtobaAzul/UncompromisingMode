local function OnLand(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    local worm = SpawnPrefab("viperling")
    if inst:HasTag("friendly") then
        worm = SpawnPrefab("viperlingfriend")
    end
    worm.Transform:SetPosition(x, y, z)
    if worm.components.combat ~= nil then
        local bozo = FindEntity(inst, 10,
            function(guy)
                if worm.components.combat:CanTarget(guy) then
                    return guy:HasTag("character")
                end
            end)
        if bozo ~= nil and not inst:HasTag("viperlingfriend") then
            bozo.components.combat:SuggestTarget(bozo)
        end
        worm.sg:GoToState("taunt")
    end
    inst:Remove()
end

local function TestProjectileLand(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    if y <= inst:GetPhysicsRadius() + 0.001 then
        OnLand(inst)
        inst:Remove()
    end
end

local function onthrown(inst)
    inst:AddTag("NOCLICK")
    inst.persists = false
    inst.AnimState:SetBank("warg_gingerbread_bomb")
    inst.AnimState:SetBuild("warg_gingerbread_bomb")
    inst.AnimState:SetMultColour(0, 0, 0, 0.4)
    inst.AnimState:PlayAnimation("spin_loop", true)

    inst.Physics:SetMass(1)
    inst.Physics:SetCapsule(0.2, 0.2)
    inst.Physics:SetFriction(0)
    inst.Physics:SetDamping(0)
    inst.Physics:SetCollisionGroup(COLLISION.CHARACTERS)
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.GROUND)
    inst.Physics:CollidesWith(COLLISION.OBSTACLES)
    inst.Physics:CollidesWith(COLLISION.ITEMS)
end

local function projectilefn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddPhysics()
    inst.entity:AddNetwork()



    inst.AnimState:SetBank("warg_gingerbread_bomb")
    inst.AnimState:SetBuild("warg_gingerbread_bomb")
    inst.AnimState:PlayAnimation("spin_loop", true)

    inst.AnimState:SetMultColour(0, 0, 0, 0.4)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("complexprojectile")
    inst.components.complexprojectile:SetHorizontalSpeed(15)
    inst.components.complexprojectile:SetGravity(-35)
    inst.components.complexprojectile:SetLaunchOffset(Vector3(0, 1, 0))
    inst.components.complexprojectile:SetOnLaunch(onthrown)
    inst.components.complexprojectile:SetOnHit(OnLand)

    inst.persists = false

    inst:AddComponent("locomotor")
    return inst
end

return Prefab("viperprojectile", projectilefn)
