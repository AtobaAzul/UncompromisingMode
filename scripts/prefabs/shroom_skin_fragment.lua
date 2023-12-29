local assets =
{
    Asset("ANIM", "anim/shroom_skin_fragment.zip"),
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("shroom_skin_fragment")
    inst.AnimState:SetBuild("shroom_skin_fragment")
    inst.AnimState:PlayAnimation("idle")

    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/shroom_skin_fragment.xml"

    MakeHauntableLaunchAndPerish(inst)
	
	inst:AddComponent("edible")
    inst.components.edible.healthvalue = 0
    inst.components.edible.hungervalue = 1
    inst.components.edible.sanityvalue = 0      
    inst.components.edible.foodtype = FOODTYPE.HORRIBLE	

    return inst
end

return Prefab("shroom_skin_fragment", fn, assets)
