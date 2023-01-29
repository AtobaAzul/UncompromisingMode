local assets =
{
    Asset("ANIM", "anim/toadstool_actions.zip"),
    Asset("ANIM", "anim/toadstool_build.zip"),
    Asset("ANIM", "anim/toadstool_dark_build.zip"),
    Asset("MINIMAP_IMAGE", "toadstool_hole"),
    Asset("MINIMAP_IMAGE", "toadstool_cap_dark"),
}


local prefabs =
{
    "rambranch",
}

local function onworked(inst, worker)
    if not (worker ~= nil and worker:HasTag("playerghost")) then
        inst.SoundEmitter:PlaySound("dontstarve/wilson/use_axe_mushroom")
    end
    inst.AnimState:PlayAnimation("mushroom_toad_hit")
end

local function onspawnram(inst)
    inst:RemoveEventCallback("animover", onspawnram)
    inst.SoundEmitter:PlaySound("dontstarve/common/mushroom_up")

    local rambranch = SpawnPrefab("rambranch")

    rambranch.Transform:SetPosition(inst.Transform:GetWorldPosition())
    rambranch.sg:GoToState("surface")
	inst:Remove()
end

local function onworkfinished(inst)
    if inst.components.workable.workable then
        inst.components.workable:SetWorkable(false)
        if inst.AnimState:IsCurrentAnimation("mushroom_toad_hit") then
            inst:ListenForEvent("animover", onspawnram)
        else
            onspawnram(inst)
        end
    end
end
local function CalcSanityAura(inst)
    return -TUNING.SANITYAURA_HUGE
end
local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

	inst.MiniMapEntity:SetIcon("toadstool_cap.png")

    inst.Transform:SetSixFaced()

    inst.AnimState:SetBank("toadstool")
    inst.AnimState:SetBuild("toadstool_build")
    inst.AnimState:PlayAnimation("mushroom_toad_idle_loop", true)


    --DO THE PHYSICS STUFF MANUALLY SO THAT WE CAN SHUT OFF THE BOSS COLLISION.
    --don't yell at me plz...
    --MakeObstaclePhysics(inst, .5)
    ----------------------------------------------------
    inst:AddTag("blocker")
    inst.entity:AddPhysics()
    inst.Physics:SetMass(0) 
    inst.Physics:SetCollisionGroup(COLLISION.OBSTACLES)
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.ITEMS)
    inst.Physics:CollidesWith(COLLISION.CHARACTERS)
    --inst.Physics:CollidesWith(COLLISION.GIANTS)
    inst.Physics:SetCapsule(.5, 2)
    ----------------------------------------------------

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("entitytracker")

    inst:AddComponent("inspectable")
	inst:AddComponent("sanityaura")
    inst.components.sanityaura.aurafn = CalcSanityAura
    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	inst:AddComponent("workable")
    inst.components.workable:SetWorkLeft(3)
    inst.components.workable:SetOnWorkCallback(onworked)
    inst.components.workable:SetOnFinishCallback(onworkfinished)
    return inst
end

return Prefab("rambranch_horn", fn, assets, prefabs)
