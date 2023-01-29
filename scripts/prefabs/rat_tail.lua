local assets =
{
    Asset("ANIM", "anim/rat_tail.zip"),
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("rat_tail")
    inst.AnimState:SetBuild("rat_tail")
    inst.AnimState:PlayAnimation("idle")

    MakeInventoryFloatable(inst)
	
    inst:AddTag("show_spoilage")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("tradable")
	inst.components.tradable.goldvalue = 2*TUNING.GOLD_VALUES.MEAT
	
    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/rat_tail.xml"
	
    inst:AddComponent("edible")
    inst.components.edible.foodtype = FOODTYPE.HORRIBLE
    inst.components.edible.healthvalue = 0
    inst.components.edible.hungervalue = 5
	
	
	
    MakeHauntableLaunchAndPerish(inst)

    return inst
end

return Prefab("rat_tail", fn, assets)
