local assets =
{
    Asset("ANIM", "anim/um_deviled_eggs.zip"),
	Asset("ATLAS", "images/inventoryimages/um_deviled_eggs.xml"),
	Asset("IMAGE", "images/inventoryimages/um_deviled_eggs.tex"),
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
	inst.entity:AddLight()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("um_deviled_eggs")
    inst.AnimState:SetBuild("um_deviled_eggs")
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
	inst.components.inventoryitem.atlasname = "images/inventoryimages/um_deviled_eggs.xml"
    inst:AddComponent("edible")
    inst.components.edible.healthvalue = -15
    inst.components.edible.hungervalue = 18.75
    inst.components.edible.sanityvalue = -20
    inst.components.edible.foodtype = FOODTYPE.MEAT
    inst.components.edible.secondaryfoodtype = FOODTYPE.MONSTER

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_FAST)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"

    MakeHauntableLaunchAndPerish(inst)
	inst:AddTag("preparedfood")

    return inst
end

return Prefab("um_deviled_eggs", fn, assets)