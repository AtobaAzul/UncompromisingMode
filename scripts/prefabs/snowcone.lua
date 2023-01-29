local assets =
{
    Asset("ANIM", "anim/snowcone.zip"),
    Asset("ATLAS", "images/inventoryimages/snowcone.xml"),
}
local function oneatenfn(inst, eater)

end
local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("snowcone")
    inst.AnimState:SetBuild("snowcone")
    inst.AnimState:PlayAnimation("idle")
    MakeInventoryFloatable(inst)
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	inst:AddTag("frozen")
    inst:AddTag("watersource")
    inst:AddComponent("stackable")

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/snowcone.xml"
    inst:AddComponent("edible")
    inst.components.edible.healthvalue = 3
    inst.components.edible.hungervalue = 9.375
    inst.components.edible.sanityvalue = 5
    inst.components.edible.foodtype = FOODTYPE.VEGGIE
    inst.components.edible.temperaturedelta = TUNING.COLD_FOOD_BONUS_TEMP
    inst.components.edible.temperatureduration = TUNING.FOOD_TEMP_BRIEF

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime((2*TUNING.PERISH_TWO_DAY))
    inst.components.perishable:StartPerishing()
	inst.components.perishable:SetOnPerishFn(function(inst) inst:Remove() end)

    MakeHauntableLaunchAndPerish(inst)
	inst.components.edible:SetOnEatenFn(oneatenfn)
	inst:AddTag("preparedfood")
    return inst
end

return Prefab("snowcone", fn, assets)
