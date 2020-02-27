local assets =
{
    -- Asset("ANIM", "anim/grass.zip"),
    Asset("ANIM", "anim/LaitLeech.zip"),
	Asset("ATLAS", "images/inventoryimages/laitleech.xml"),
	Asset("IMAGE", "images/inventoryimages/laitleech.tex"),
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("LaitLeech")
    inst.AnimState:SetBuild("LaitLeech")
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
	inst.components.inventoryitem.atlasname = "images/inventoryimages/laitleech.xml"
    inst:AddComponent("edible")
    inst.components.edible.healthvalue = 5
    inst.components.edible.hungervalue = 5
    inst.components.edible.sanityvalue = -25
    inst.components.edible.foodtype = FOODTYPE.VEGGIE

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_TWO_DAY)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"

    MakeHauntableLaunchAndPerish(inst)

    return inst
end

return Prefab("laitleech", fn, assets)
