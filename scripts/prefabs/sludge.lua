local assets =
{
    Asset("ANIM", "anim/sludge_oil.zip"),
    Asset("ANIM", "anim/sludge_plug.zip"),
    Asset("ANIM", "anim/sludge.zip"),
    Asset("ANIM", "anim/boat_repair_sludge_build.zip")
}

local function ontaken(inst, taker)
    local pot1, pot2 = SpawnPrefab("halloweenpotion_embers"), SpawnPrefab("halloweenpotion_sparks")
    if taker.components.fueled:CanAcceptFuelItem(pot1) and taker.components.fueled:CanAcceptFuelItem(pot2) then
        taker.components.fueled:TakeFuelItem(pot1)
        taker.components.fueled:TakeFuelItem(pot2)
    else
        pot1:Remove()
        pot2:Remove()
    end
end

local function onfinished(inst)
    local bottle = SpawnPrefab("messagebottleempty")

    local owner = inst.components.inventoryitem:GetGrandOwner()

    if owner ~= nil and owner.components.inventory ~= nil then
        local x, y, z = owner.Transform:GetWorldPosition()
        bottle.Transform:SetPosition(x, y, z)
        owner.components.inventory:GiveItem(bottle)
    else
        Launch2(bottle, inst, 1.5, 1, 3, .75)
    end

    inst:Remove()
end

local function sludge_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("sludge")
    inst.AnimState:SetBuild("sludge")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("allow_action_on_impassable")
    inst:AddTag("boat_patch")

    MakeInventoryFloatable(inst, "med", 0.05, 0.6)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.LARGE_FUEL
    inst.components.fuel.fueltype = FUELTYPE.SLUDGE
    inst.components.fuel:SetOnTakenFn(ontaken) -- :)

    inst:AddComponent("repairer")
    inst.components.repairer.repairmaterial = MATERIALS.SLUDGE
    inst.components.repairer.healthrepairvalue = TUNING.REPAIR_TREEGROWTH_HEALTH
    inst.components.repairer.boatrepairsound = "waterlogged1/common/use_figjam"

    inst:AddComponent("boatpatch")
    inst.components.boatpatch.patch_type = "sludge"

    MakeSmallBurnable(inst, TUNING.LARGE_BURNTIME)
    MakeSmallPropagator(inst)

    MakeHauntableLaunchAndIgnite(inst)

    ---------------------

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/sludge.xml"

    return inst
end

local function onactiveitem(item, inst)
    item.components.inventoryitem:SetOwner(inst)
end

local function oil_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("sludge_oil")
    inst.AnimState:SetBuild("sludge_oil")
    inst.AnimState:PlayAnimation("idle")

    MakeInventoryFloatable(inst, "med", 0.05, 0.6)

    inst:AddTag("sludge_oil")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.LARGE_FUEL * 2
    inst.components.fuel.fueltype = FUELTYPE.SLUDGE
    inst.components.fuel:SetOnTakenFn(ontaken) -- :)

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(25)
    inst.components.finiteuses:SetUses(25)
    inst.components.finiteuses:SetOnFinished(onfinished)

    MakeSmallBurnable(inst, TUNING.LARGE_BURNTIME)
    MakeSmallPropagator(inst)

    MakeHauntableLaunchAndIgnite(inst)

    ---------------------

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/sludge_oil.xml"
    inst.components.inventoryitem.onactiveitemfn = onactiveitem

    return inst
end

local function bucket_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("sludge_plug")
    inst.AnimState:SetBuild("sludge_plug")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("allow_action_on_impassable")

    MakeInventoryFloatable(inst, "med", 0.05, 0.6)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.LARGE_FUEL

    MakeSmallBurnable(inst, TUNING.LARGE_BURNTIME)
    MakeSmallPropagator(inst)

    MakeHauntableLaunchAndIgnite(inst)

    ---------------------

    inst:AddComponent("inspectable")

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/sludge_cork.xml"

    inst:AddComponent("tradable")
    inst:AddComponent("upgrader")
    inst.components.upgrader.upgradetype = UPGRADETYPES.SLUDGE_CORK
    inst.components.upgrader.upgradevalue = 2 --hm

    return inst
end

return Prefab("sludge", sludge_fn, assets), Prefab("sludge_oil", oil_fn, assets), Prefab("sludge_cork", bucket_fn, assets)
