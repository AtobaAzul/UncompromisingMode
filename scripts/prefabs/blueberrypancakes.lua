local assets =
{
    Asset("ANIM", "anim/blueberrypancakes.zip"),
	Asset("ATLAS", "images/inventoryimages/blueberrypancakes.xml"),
}
local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("blueberrypancakes")
    inst.AnimState:SetBuild("blueberrypancakes")
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
	inst.components.inventoryitem.atlasname = "images/inventoryimages/blueberrypancakes.xml"
    inst:AddComponent("edible")
    inst.components.edible.healthvalue = 5
    inst.components.edible.hungervalue = 75
    inst.components.edible.sanityvalue = 20
    inst.components.edible.foodtype = FOODTYPE.VEGGIE
	inst:AddComponent("tradable")
    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_SLOW) -- 15 days
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"

    MakeHauntableLaunchAndPerish(inst)
	inst:AddTag("preparedfood")
    return inst
end

return Prefab("blueberrypancakes", fn,assets)
