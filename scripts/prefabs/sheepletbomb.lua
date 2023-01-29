local function MakeProjectile(name)
    local assets =
    {
        Asset("ANIM", "anim/sheepletbomb.zip"),
    }
    --if bombname ~= "mushroombomb" then
        --table.insert(assets, Asset("ANIM", "anim/mushroombomb_build.zip"))
   -- end

    local prefabs =
    {
        "sheeplet",
    }

    local function OnProjectileHit(inst)
        local x, y, z = inst.Transform:GetWorldPosition()
        inst:Remove()
        local bomb = SpawnPrefab("sheeplet")
        bomb.Transform:SetPosition(x, y, z)
        bomb.SoundEmitter:PlaySound("dontstarve/creatures/together/toad_stool/spore_land")
        local rambranch = inst.components.entitytracker:GetEntity("rambranch")
        if rambranch ~= nil then
            bomb.components.entitytracker:TrackEntity("rambranch", rambranch)
        end
    end

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
        inst.Physics:CollidesWith(COLLISION.WORLD)
        inst.Physics:SetCapsule(.2, .2)

        inst.AnimState:SetBank("sheepletbomb")
        inst.AnimState:SetBuild("sheepletbomb")
        inst.AnimState:PlayAnimation("projectile_loop", true)

        inst:AddTag("NOCLICK")

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("locomotor")

        inst:AddComponent("complexprojectile")
        inst.components.complexprojectile:SetHorizontalSpeed(15)
        inst.components.complexprojectile:SetGravity(-25)
        inst.components.complexprojectile:SetLaunchOffset(Vector3(0, 2.5, 0))
        inst.components.complexprojectile:SetOnHit(OnProjectileHit)
		inst.target = nil
        inst:AddComponent("entitytracker")

        inst.persists = false

        return inst
    end

    return Prefab(name, fn, assets, prefabs)
end

return MakeProjectile("sheepletbomb", "mushroombomb")
