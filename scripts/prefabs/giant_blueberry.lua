local assets =
{
    Asset("ANIM", "anim/blueberry.zip"),
	Asset("ATLAS", "images/inventoryimages/giant_blueberry.xml"),
	Asset("IMAGE", "images/inventoryimages/giant_blueberry.tex"),
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
	inst.entity:AddLight()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("blueberry")
    inst.AnimState:SetBuild("blueberry")
    inst.AnimState:PlayAnimation("idle")
	inst.Transform:SetScale(1.2,1.2,1.2)
    MakeInventoryFloatable(inst)
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/giant_blueberry.xml"
    inst:AddComponent("edible")
    inst.components.edible.healthvalue = 3
    inst.components.edible.hungervalue = 22.5
    inst.components.edible.sanityvalue = 0
    inst.components.edible.foodtype = FOODTYPE.VEGGIE

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(2.5*TUNING.PERISH_TWO_DAY)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"

    MakeHauntableLaunchAndPerish(inst)
    return inst
end

return Prefab("giant_blueberry", fn, assets)
