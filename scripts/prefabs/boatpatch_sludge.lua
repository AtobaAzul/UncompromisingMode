local assets =
{
    Asset("ANIM", "anim/boat_repair_build.zip"),
    Asset("ANIM", "anim/boat_repair_cork_build.zip"),
}

local prefabs =
{
    "fishingnetvisualizer"
}

local function onactiveitem(item, inst)
    item.components.inventoryitem:SetOwner(inst)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    inst:AddTag("allow_action_on_impassable")
    inst:AddTag("boat_patch")

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("boat_repair")
    inst.AnimState:SetBuild("boat_repair_cork_build")
    inst.AnimState:PlayAnimation("item")

    MakeInventoryFloatable(inst, "med", 0.1)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("boatpatch")
    inst.components.boatpatch.patch_type = "driftwood"

    inst:AddComponent("repairer")
    inst.components.repairer.repairmaterial = MATERIALS.WOOD
    inst.components.repairer.healthrepairvalue = TUNING.REPAIR_LOGS_HEALTH * 2
    inst.components.repairer.boatrepairsound = "turnoftides/common/together/boat/repair_with_wood"

    inst:AddComponent("finiteuses")
    --inst.components.finiteuses:SetConsumption(ACTIONS.REPAIR_LEAK, 1)
    inst.components.finiteuses:SetMaxUses(10)
    inst.components.finiteuses:SetUses(10)
    inst.components.finiteuses:SetOnFinished(inst.Remove)--onfinished

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.onactiveitemfn = onactiveitem

    inst:AddComponent("inspectable")

    MakeSmallBurnable(inst, TUNING.MED_BURNTIME)
    MakeSmallPropagator(inst)

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.MED_FUEL * 2 -- 2x logs

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("boatpatch_sludge", fn, assets, prefabs)