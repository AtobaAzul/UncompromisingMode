local assets =
{
    Asset("ANIM", "anim/simpsalad.zip"),
	Asset("ATLAS", "images/inventoryimages/simpsalad.xml"),
}
local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("simpsalad")
    inst.AnimState:SetBuild("simpsalad")
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
	inst.components.inventoryitem.atlasname = "images/inventoryimages/simpsalad.xml"
    inst:AddComponent("edible")
    inst.components.edible.healthvalue = 3
    inst.components.edible.hungervalue = 12.5
    inst.components.edible.sanityvalue = 5
    inst.components.edible.foodtype = FOODTYPE.VEGGIE
	inst:AddComponent("tradable")
    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime((2*TUNING.PERISH_TWO_DAY))
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"

    MakeHauntableLaunchAndPerish(inst)
	inst:AddTag("preparedfood")
    return inst
end

return Prefab("simpsalad", fn,assets)
