require "prefabutil"

local assets =
{
    Asset("ANIM", "anim/whisperpod.zip"),
}

local prefabs =
{
    "plant_normal_ground",
}

local function OnDeploy(inst, pt)--, deployer, rot)
    local plant = SpawnPrefab("whisperpod_normal_ground")
    plant.Transform:SetPosition(pt.x, 0, pt.z)
    plant.SoundEmitter:PlaySound("dontstarve/wilson/plant_seeds")
    inst:Remove()
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("whisperpod")
    inst.AnimState:SetBuild("whisperpod")
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:SetRayTestOnBB(true)

    MakeInventoryFloatable(inst)
	
    inst:AddTag("deployedplant")
	inst:AddTag("plant")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("deployable")
    inst.components.deployable:SetDeployMode(DEPLOYMODE.PLANT)
    inst.components.deployable.ondeploy = OnDeploy
	
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/whisperpod.xml"

    inst:AddComponent("inspectable")
	
    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.MED_FUEL

    MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
    MakeSmallPropagator(inst)
    MakeHauntableLaunchAndPerish(inst)

    return inst
end

return Prefab("whisperpod", fn, assets, prefabs),
    MakePlacer("whisperpod_placer", "whisperpod_normal_ground", "whisperpod_normal_ground", "placer")
