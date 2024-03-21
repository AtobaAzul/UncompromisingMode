local assets =
{
    Asset("ANIM", "anim/rockjawleather.zip"),
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("rockjawleather")
    inst.AnimState:SetBuild("rockjawleather")
    inst.AnimState:PlayAnimation("idle")

    MakeInventoryFloatable(inst, "med", nil, 0.77)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM

    inst:AddComponent("inspectable")

    MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)
    MakeHauntableLaunchAndIgnite(inst)

    inst:AddComponent("tradable")
    inst.components.tradable.goldvalue = 4

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/rockjawleather.xml"
	
	inst:AddComponent("edible")
    inst.components.edible.healthvalue = -5
    inst.components.edible.hungervalue = 10
    inst.components.edible.sanityvalue = 0      
    inst.components.edible.foodtype = FOODTYPE.HORRIBLE

    return inst
end

return Prefab("rockjawleather", fn, assets)